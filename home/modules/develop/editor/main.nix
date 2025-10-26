{ ... }:
let
  terminals = "neovim";
in
{
  imports = [
    ./terminals/${terminals}/main.nix
    ./zeditor.nix
  ];
}
