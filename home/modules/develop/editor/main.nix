{ ... }:
let
  terminals = "helix";
in
{
  imports = [
    ./terminals/${terminals}/main.nix
    ./vibe.nix
    ./zeditor.nix
  ];
}
