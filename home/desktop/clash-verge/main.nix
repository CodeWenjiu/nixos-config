{ ... }:
{
  # Clash Verge's profile chain (merge/script/rules) lives in its XDG data dir,
  # which is application state, not configuration: the GUI rewrites it, and
  # every subscription update regenerates the merged config from it. The global
  # Script profile is the only hook that runs on *every* generation, so the
  # tailnet fixes live there (see Script.js next to this file). Edit that file
  # in the repo - the GUI can no longer save over it.
  home.file.".local/share/io.github.clash-verge-rev.clash-verge-rev/profiles/Script.js" = {
    source = ./Script.js;
    force = true;
  };
}
