{config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  programs.kitty = {
    font.name = "Iosevka";
    font.size = 16.0;
  };

  programs.rofi.font = "Iosevka 16";

  programs.swaylock.enable = true;

  home.file = {
    ".config/sway".source = .config/sway;
  };
}
