#!/usr/bin/env node
// zed-thread-prune — bound the size of Zed's stored agent-thread history.
//
// Every thread lives in a single zstd blob in
//   ~/.local/share/zed/threads/threads.db
// and is decompressed + deserialized in full whenever its workspace (or the
// thread itself) opens. Zed's compaction only shrinks what the *model* sees;
// it never drops stored messages, so a long-lived thread slowly turns into a
// multi-megabyte blob that makes opening that workspace take seconds.
//
// Policy (defaults, all overridable on the command line):
//   * only threads idle for --min-age-days (7) are touched, so anything
//     currently open in Zed is out of reach;
//   * only threads larger than --min-size-mb (2) are considered at all;
//   * the thread keeps its last --keep (100) messages, bounded to ~12 MB of
//     raw JSON, never fewer than the last 20 messages;
//   * the dropped prefix is archived as zstd JSON under
//     ~/.local/share/zed-thread-archive/ before it is removed.
//
// Usage: zed-thread-prune [--list [--top N]] [--dry-run] [--min-age-days N] [--min-size-mb N] [--keep N]

const fs = require("node:fs");
const path = require("node:path");
const zlib = require("node:zlib");
const { DatabaseSync } = require("node:sqlite");

const KEEP_MIN = 20;
const RAW_CAP = 12 * 1024 * 1024;
const MB = 1024 * 1024;

const opt = { list: false, top: 10, dryRun: false, minAgeDays: 7, minSizeMb: 2, keep: 100 };
const argv = process.argv.slice(2);
for (let i = 0; i < argv.length; i++) {
  const flag = argv[i];
  if (flag === "--list") opt.list = true;
  else if (flag === "--top") opt.top = Number(argv[++i]);
  else if (flag === "--dry-run") opt.dryRun = true;
  else if (flag === "--min-age-days") opt.minAgeDays = Number(argv[++i]);
  else if (flag === "--min-size-mb") opt.minSizeMb = Number(argv[++i]);
  else if (flag === "--keep") opt.keep = Number(argv[++i]);
  else {
    console.error(`zed-thread-prune: unknown argument '${flag}'`);
    process.exit(2);
  }
}

const home = process.env.HOME;
if (!home) {
  console.error("zed-thread-prune: HOME is not set");
  process.exit(1);
}
const dbPath = path.join(home, ".local/share/zed/threads/threads.db");
const archiveDir = path.join(home, ".local/share/zed-thread-archive");

if (!fs.existsSync(dbPath)) {
  console.log(`zed-thread-prune: ${dbPath} not found, nothing to do`);
  process.exit(0);
}

const db = new DatabaseSync(dbPath);
db.exec("PRAGMA busy_timeout = 15000");

if (opt.list) {
  const dbSize = fs.statSync(dbPath).size;
  const count = db.prepare("SELECT count(*) AS c FROM threads").get().c;
  console.log(`threads.db: ${(dbSize / MB).toFixed(1)}MB, ${count} threads - largest ${opt.top}:`);
  const top = db
    .prepare(
      "SELECT id, summary, updated_at, length(data) AS bytes FROM threads " +
        "ORDER BY bytes DESC LIMIT ?",
    )
    .all(opt.top);
  for (const row of top) {
    console.log(
      `${(row.bytes / MB).toFixed(2).padStart(7)}MB  ${row.updated_at.slice(0, 10)}  ` +
        `${row.id.slice(0, 8)}  ${row.summary}`,
    );
  }
  let archiveBytes = 0;
  let archiveFiles = 0;
  if (fs.existsSync(archiveDir)) {
    for (const name of fs.readdirSync(archiveDir)) {
      const stat = fs.statSync(path.join(archiveDir, name));
      if (stat.isFile()) {
        archiveBytes += stat.size;
        archiveFiles++;
      }
    }
  }
  console.log(`archive: ${(archiveBytes / MB).toFixed(1)}MB in ${archiveFiles} file(s) at ${archiveDir}`);
  process.exit(0);
}

const minBytes = opt.minSizeMb * MB;
const minAgeMs = opt.minAgeDays * 24 * 60 * 60 * 1000;
const rows = db
  .prepare(
    "SELECT id, summary, updated_at, data FROM threads " +
      "WHERE data_type = 'zstd' AND length(data) > ? ORDER BY length(data) DESC",
  )
  .all(minBytes);

let scanned = 0;
let changed = 0;
let freed = 0;

for (const row of rows) {
  scanned++;
  const updated = Date.parse(row.updated_at);
  if (!Number.isFinite(updated)) {
    console.error(
      `zed-thread-prune: ${row.id.slice(0, 8)}: unparseable date '${row.updated_at}', skipped`,
    );
    continue;
  }
  if (Date.now() - updated < minAgeMs) continue;

  try {
    const thread = JSON.parse(zlib.zstdDecompressSync(row.data).toString("utf8"));
    const messages = thread.messages;
    if (!Array.isArray(messages) || messages.length <= KEEP_MIN) continue;

    // Walk from the end: keep at least KEEP_MIN messages, at most opt.keep,
    // and stop once the raw JSON budget is used up.
    let keep = 0;
    let raw = 0;
    for (let i = messages.length - 1; i >= 0; i--) {
      const size = JSON.stringify(messages[i]).length;
      if (keep >= opt.keep) break;
      if (keep >= KEEP_MIN && raw + size > RAW_CAP) break;
      raw += size;
      keep++;
    }
    const removed = messages.length - keep;
    if (removed < 10) continue; // not worth touching

    const archive = {
      id: row.id,
      title: row.summary,
      updated_at: row.updated_at,
      archived_at: new Date().toISOString(),
      removed_messages: messages.slice(0, removed),
    };
    const archived = zlib.zstdCompressSync(Buffer.from(JSON.stringify(archive)));
    thread.messages = messages.slice(removed);
    const pruned = zlib.zstdCompressSync(Buffer.from(JSON.stringify(thread)));

    console.log(
      `${opt.dryRun ? "[dry-run] " : ""}${row.id.slice(0, 8)} "${row.summary}": ` +
        `${(row.data.length / MB).toFixed(1)}MB -> ${(pruned.length / MB).toFixed(1)}MB, ` +
        `messages ${messages.length} -> ${keep}, archived ${(archived.length / MB).toFixed(1)}MB`,
    );

    if (!opt.dryRun) {
      fs.mkdirSync(archiveDir, { recursive: true });
      fs.writeFileSync(
        path.join(archiveDir, `${row.updated_at.slice(0, 10)}-${row.id.slice(0, 8)}.json.zst`),
        archived,
      );
      db.prepare("UPDATE threads SET data = ? WHERE id = ?").run(pruned, row.id);
    }
    changed++;
    freed += row.data.length - pruned.length;
  } catch (error) {
    console.error(`zed-thread-prune: ${row.id.slice(0, 8)}: ${error.message}, skipped`);
  }
}

if (!opt.dryRun && changed > 0) {
  try {
    db.exec("VACUUM");
  } catch (error) {
    console.error(`zed-thread-prune: VACUUM failed: ${error.message}`);
  }
}

console.log(
  `zed-thread-prune: scanned ${scanned}, ${opt.dryRun ? "would prune" : "pruned"} ${changed}, ` +
    `~${(freed / MB).toFixed(1)}MB ${opt.dryRun ? "savable" : "freed"}`,
);
