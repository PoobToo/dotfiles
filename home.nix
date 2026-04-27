{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.username = "leo";
  home.homeDirectory = "/home/leo";

  home.packages = with pkgs; [
    firefox
    tmux
    foot
    claude-code
    wineWowPackages.stable
    winetricks
    xwayland-satellite
    yazi
    uv
    tealdeer
    logseq

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
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "Leo";
      email = "leo@radish";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting
    '';
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#radish && home-manager switch --flake ~/nixos#leo";
      battery = "cat /sys/class/power_supply/BATT/capacity";
      cat = "bat";
      jj = "vim ~/logseq/journals/$(date +%Y_%m_%d).md";
    };
    plugins = [
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
    ];
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#radish && home-manager switch --flake ~/nixos#leo";
      battery = "cat /sys/class/power_supply/BATT/capacity";
      jj = "vim ~/logseq/journals/$(date +%Y_%m_%d).md";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$python$rust$nodejs$nix_shell$cmd_duration$line_break$character";
      directory = {
        style = "blue bold";
      };
      git_branch = {
        format = "[$branch]($style) ";
        style = "purple";
      };
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
      };
      python = {
        format = "[($virtualenv )$version]($style) ";
      };
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        min_time = 5000;
      };
    };
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.niri = {
    settings = {
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
      ];
      input.keyboard.xkb.layout = "us";

      binds = {
        "Mod+Return".action.spawn = [ "foot" ];
        "Mod+Q".action.close-window = [];
        "Mod+Shift+E".action.quit = {};

        # Focus
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};

        # Move windows
        "Mod+Shift+Left".action.move-column-left = {};
        "Mod+Shift+Right".action.move-column-right = {};
        "Mod+Shift+Up".action.move-window-up = {};
        "Mod+Shift+Down".action.move-window-down = {};

        # Workspaces
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;

        # Layout
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
      };
    };
  };

  programs.bat.enable = true;
  programs.fzf.enable = true;

  # Desktop shell (temporary — will replace with custom quickshell)
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = false;
  };

  # Let home-manager manage itself in standalone mode
  programs.home-manager.enable = true;

  home.stateVersion = "25.11";
}
