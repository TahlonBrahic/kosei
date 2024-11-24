{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.virtualization;
in {
  options = {
    virtualization = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      distrobox
      docker-compose
      podman
      podman-tui
      skopeo
      kubectl
      kubevirt
    ];

    programs.k9s.enable = true;
  };
}
