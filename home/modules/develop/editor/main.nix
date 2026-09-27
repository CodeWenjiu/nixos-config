{ ... }:
let
  terminals = "helix";
in
{
  imports = [
    ./terminals/${terminals}/main.nix
    ./zeditor.nix
    ./zed-thread-prune.nix
    ./vscode.nix
    ./vibe.nix
  ];
}
