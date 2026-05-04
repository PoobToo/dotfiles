{ pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    tmux
    # foot — managed by programs.foot
    claude-code
    xwayland-satellite
    uv
    tealdeer


    # Archives
    unzip
    zip
    unrar
    p7zip
    xz

    # File tools
    ripgrep
    fd
    file
    imagemagick

    # Wayland / niri desktop
    wl-clipboard
    grim
    slurp
    mako
    fuzzel

    # Media
    mpv
    imv

    # CLI utilities
    wget
    btop
    rsync
    jq
    age
    nodejs_22
  ];
}
