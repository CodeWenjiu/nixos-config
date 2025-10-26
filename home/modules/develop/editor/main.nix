{ ... }:
let
  terminals = "neovim";
in
{
  imports = [
    ./terminals/${terminals}.nix
    ./zeditor.nix
  ];
}
