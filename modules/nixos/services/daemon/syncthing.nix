_: {
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.frostbite.services.daemon.syncthing;
in {
  options = {
    frostbite.services.daemon.syncthing = {
      enable = lib.mkEnableOption "syncthing";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = {
        enable = true;
        package = pkgs.syncthing;
        relay.enable = true;
        user = "syncthing";
        systemService = true;
        extraFlags = [
          "--audit"
          "--no-browser"
          "--no-restart"
        ];
        dataDir = "/var/lib/syncthing";
        configDir = "/var/lib/syncthing/.config/syncthing";
        databaseDir = "/var/lib/syncthing/.config/syncthing";
        guiAddress = "127.0.0.1:8301";
        openDefaultPorts = true; # TCP/UDP 22000 for transfers and UDP 21027 for discovery.
        # inherit (cfg) settings; # Each consumer of this module defines their
        # individual settings on their side.
      };
    };
    # Syncthing ports: 8301 for remote access to GUI
    # 22000 TCP and/or UDP for sync traffic
    # 21027/UDP for discovery
    # source: https://docs.syncthing.net/users/firewall.html
    networking.firewall = {
      allowedTCPPorts = [8301 22000];
      allowedUDPPorts = [22000 21027];
    };

    # Do not create default ~/Sync folder
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";

    environment.persistence = lib.mkIf config.frostbite.security.impermanence.enable {
      "/nix/persistent/".directories = ["/var/lib/syncthing"];
    };
  };
}
