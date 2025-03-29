_: {
  config,
  lib,
  ...
}: let
  cfg = config.frostbite.hardware.tpm;
in {
  options.frostbite.hardware.tpm.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.tcsd.enable = true;
  };
}
