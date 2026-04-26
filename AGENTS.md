# Repository Guidelines

## Project Structure & Module Organization
This repository is a flake-based NixOS + Home Manager setup.

- `flake.nix`: entry point, inputs, and `nixosConfigurations`.
- `configuration.nix`: top-level system imports and global settings.
- `basic/`: baseline OS setup (boot, desktop, I/O).
- `modules/`: reusable system modules (for example `clash.nix`, `rime.nix`).
- `platform/`: hardware/platform-specific system wiring.
- `hosts/<host>/hardware-configuration.nix`: host-generated hardware config.
- `home/`: Home Manager configuration tree.
- `home/modules/{essential,media,develop}/`: user module groups.
- `home/desktop/` and `home/style/`: desktop environment and theme layers.

Prefer adding new behavior as a small module and importing it from the nearest `main.nix`.

## Build, Test, and Development Commands
- `sudo nixos-rebuild switch --flake .#<host>`: build and activate system config.
- `sudo nixos-rebuild test --flake .#<host>`: activate temporarily for validation.
- `sudo nixos-rebuild build --flake .#<host>`: build only (no activation).
- `nix flake check`: evaluate flake and run defined checks.
- `sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix`: bootstrap a new host hardware file.

Use `wenjiu` as the host name unless you are adding a new host target.

## Coding Style & Naming Conventions
- Language: Nix (`.nix`), with 2-space indentation and semicolon-terminated attributes.
- Keep modules focused; avoid large, mixed-purpose files.
- Follow local naming patterns in each directory (mostly lowercase with `-` or `_`).
- Keep import lists readable (group related modules together).

No repository-enforced formatter/linter is currently configured; keep style consistent with neighboring files.

## Testing Guidelines
There is no unit-test framework in this repo. Validation is build/evaluation based:

1. Run `nix flake check`.
2. Run `sudo nixos-rebuild build --flake .#<host>`.
3. For risky desktop/service changes, run `sudo nixos-rebuild test --flake .#<host>` before switching.

## Commit & Pull Request Guidelines
- Follow the existing commit style: concise Conventional Commit-like prefixes such as `chore:` and `fix:`.
- Keep commits scoped to one logical change.
- In PRs, include:
  - affected modules/paths,
  - target host(s),
  - commands run and outcomes,
  - screenshots for UI/theme changes under `home/desktop` or `home/style`.

## Security & Configuration Tips
- Do not commit secrets, tokens, or private keys.
- Keep machine-specific settings in `hosts/<host>/`.
- Review `flake.lock` updates carefully; separate dependency bumps from functional changes when possible.
