{config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  programs.kitty = {
    font.name = "Iosevka";
    font.size = 16.0;
  };

  programs.rofi.font = "Iosevka 16";

  programs.swaylock.enable = true;
  services.poweralertd.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  home.file = {
    ".config/sway".source = .config/sway;
    ".config/neofetch/logo".source = .config/neofetch/logo;
  };

  home.packages = with pkgs; [
    anki
    emacs
    firefox
    qbittorrent
    thunderbird
    vlc
    libreoffice-qt
  ];
}
