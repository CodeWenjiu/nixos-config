{ ... }:
let
  terminals = "helix";
in
{
  imports = [
    ./terminals/${terminals}/main.nix
    ./zeditor.nix
    ./cursor.nix
  ];
}
