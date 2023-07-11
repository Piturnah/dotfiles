# Created with lots of reference to this very useful site:
# https://nix-community.github.io/home-manager/options.html
{ config, pkgs, lib, ... }:

{
  home.username = "pit";
  home.homeDirectory = "/home/pit";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.shellAliases = {
    cd = "z";
    ls = "exa --group-directories-first";
    cat = "bat";
    t = "tree --gitignore";
    g = "gex";
    c = "clear";
    neofetch = "neofetch --ascii ~/.config/neofetch/logo";
  };

  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];

  programs.bash = {
    enable = true;
    bashrcExtra = "eval \"$(zoxide init bash)\"";
    profileExtra = "fcitx5 -d";
  };

  programs.git = {
    enable = true;
    userEmail = "peterhebden6@gmail.com";
    userName = "Peter Hebden";
    signing = {
      key = "DC75A84A1D77FB6A6B29282BDF01A73ED0B9AD51";
      signByDefault = false;
    };
    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";
      credential.helper = "store";
    };
  };

  programs.kitty = lib.mkDefault {
    enable = true;
    font = {
      name = "Iosevka";
      size = 14;
    };
    theme = "Gruvbox Dark";
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      cursor_blink_interval = 0;
      mouse_hide_wait = "0.5";
    };
    shellIntegration.enableBashIntegration = true;
  };

  programs.rofi = lib.mkDefault {
    enable = true;
    theme = "gruvbox-dark";
    font = "Iosevka 14";
  };

  programs.bat = {
    enable = true;
    config.theme = "gruvbox-dark";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  home.packages = with pkgs; [
    cbonsai
    cmatrix
    exa
    file
    git
    htop
    neofetch
    onefetch
    tokei
    tree
    wget
    wl-clipboard
    ripgrep
    fd
    xorg.xkill
    zoxide
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "Iosevka" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/pit/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
