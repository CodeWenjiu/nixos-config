{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # Import the lazy pool with the user's nixpkgs config (e.g. allowUnfree),
  # matching how home-manager builds its own pkgs set.
  lazyPkgs = import inputs.nixpkgs-lazy {
    system = pkgs.stdenv.hostPlatform.system;
    config = config.nixpkgs.config;
  };
in
{
  # Declare which packages come from the lazily-updated nixpkgs-lazy pool.
  # Add e.g. `wenjiu.lazyPackages = [ "wechat" ];` in the module that uses
  # the package, so the dependency stays co-located with its consumer.
  options.wenjiu.lazyPackages = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = ''
      Package names to source from the lazily-updated nixpkgs-lazy pool
      instead of the rolling main nixpkgs. Updated only via sysup-extra.
    '';
  };

  config.nixpkgs.overlays = [
    (final: prev: lib.genAttrs config.wenjiu.lazyPackages (name: lazyPkgs.${name}))
  ];
}
