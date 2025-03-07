scoped: {pkgs, ...}:
pkgs.runCommand "yubikeyInit" ''
  nix-shell -p pam_u2f --run "mkdir -p ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys"
''
