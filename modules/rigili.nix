{ pkgs, inputs, ... }:
{
  # Rigili 自己没有 NixOS/Home Manager 模块,flake 里只有 packages.default
  # （含 .desktop、图标，以及设置 LD_LIBRARY_PATH / VK_ICD_FILENAMES 的
  # wrapProgram），所以这里只把它放进 systemPackages。
  environment.systemPackages = [
    inputs.rigili.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
