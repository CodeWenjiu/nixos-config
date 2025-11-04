{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    glsl_analyzer # OpenGL Shader Script
  ];
}
