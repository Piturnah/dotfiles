{config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  home.file = {
    ".config/i3".source = .config/i3;
  };
}
