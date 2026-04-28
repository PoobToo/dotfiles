{ ... }:

{
  programs.niri = {
    settings = {
      spawn-at-startup = [
        { command = [ "xwayland-satellite" ]; }
      ];
      input = {
        keyboard.xkb.layout = "us";
        focus-follows-mouse.enable = true;
        workspace-auto-back-and-forth = true;
      };

      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      environment = {
        DISPLAY = ":0";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
      };

      layout = {
        gaps = 16;
        center-focused-column = "never";
        default-column-width.proportion = 0.5;
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        focus-ring = {
          width = 3;
        };
        shadow = {
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
        };
      };

      animations = {
        workspace-switch.kind.spring = { damping-ratio = 1.0; stiffness = 1000; epsilon = 0.0001; };
        window-open.kind.easing = { duration-ms = 100; curve = "ease-out-quad"; };
        window-close.kind.easing = { duration-ms = 200; curve = "ease-out-cubic"; };
        horizontal-view-movement.kind.spring = { damping-ratio = 1.0; stiffness = 900; epsilon = 0.0001; };
        window-movement.kind.spring = { damping-ratio = 1.0; stiffness = 800; epsilon = 0.0001; };
        window-resize.kind.spring = { damping-ratio = 1.0; stiffness = 1000; epsilon = 0.0001; };
      };

      window-rules = [
        {
          matches = [{ app-id = "firefox$"; title = "^Picture-in-Picture$"; }];
          open-floating = true;
        }
        {
          geometry-corner-radius = {
            top-left = 20.0;
            top-right = 20.0;
            bottom-left = 20.0;
            bottom-right = 20.0;
          };
          clip-to-geometry = true;
        }
      ];

      binds = {
        # Applications
        "Mod+Return".action.spawn = [ "foot" ];
        "Mod+R" = { action.spawn = [ "dms" "ipc" "call" "spotlight" "open" ]; };
        "Mod+Shift+Slash".action.show-hotkey-overlay = {};

        # Window management
        "Mod+Q".action.close-window = [];
        "Mod+Shift+E".action.quit = {};
        "Mod+O" = { repeat = false; action.toggle-overview = {}; };

        # Focus — arrows + hjkl
        "Mod+Left".action.focus-column-left = {};
        "Mod+Right".action.focus-column-right = {};
        "Mod+Up".action.focus-window-up = {};
        "Mod+Down".action.focus-window-down = {};
        "Mod+H".action.focus-column-left = {};
        "Mod+L".action.focus-column-right = {};
        "Mod+K".action.focus-window-up = {};
        "Mod+J".action.focus-window-down = {};

        # Move — Ctrl+arrows + Ctrl+hjkl
        "Mod+Ctrl+Left".action.move-column-left = {};
        "Mod+Ctrl+Right".action.move-column-right = {};
        "Mod+Ctrl+Up".action.move-window-up = {};
        "Mod+Ctrl+Down".action.move-window-down = {};
        "Mod+Ctrl+H".action.move-column-left = {};
        "Mod+Ctrl+L".action.move-column-right = {};
        "Mod+Ctrl+K".action.move-window-up = {};
        "Mod+Ctrl+J".action.move-window-down = {};

        # Workspaces — navigate with U/I and Page_Up/Down
        "Mod+U".action.focus-workspace-down = {};
        "Mod+I".action.focus-workspace-up = {};
        "Mod+Page_Down".action.focus-workspace-down = {};
        "Mod+Page_Up".action.focus-workspace-up = {};
        "Mod+Ctrl+U".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+I".action.move-column-to-workspace-up = {};
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = {};
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = {};
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        # Scroll wheel workspace/column switching
        "Mod+WheelScrollDown" = { cooldown-ms = 150; action.focus-workspace-down = {}; };
        "Mod+WheelScrollUp" = { cooldown-ms = 150; action.focus-workspace-up = {}; };
        "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action.move-column-to-workspace-down = {}; };
        "Mod+Ctrl+WheelScrollUp" = { cooldown-ms = 150; action.move-column-to-workspace-up = {}; };
        "Mod+WheelScrollRight".action.focus-column-right = {};
        "Mod+WheelScrollLeft".action.focus-column-left = {};

        # Layout
        "Mod+F".action.maximize-column = {};
        "Mod+Shift+F".action.fullscreen-window = {};
        "Mod+Ctrl+F".action.expand-column-to-available-width = {};
        "Mod+C".action.center-column = {};
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+BracketLeft".action.consume-or-expel-window-left = {};
        "Mod+BracketRight".action.consume-or-expel-window-right = {};
        "Mod+Comma".action.consume-window-into-column = {};
        "Mod+Period".action.expel-window-from-column = {};
        "Mod+V".action.toggle-window-floating = {};
        "Mod+W".action.toggle-column-tabbed-display = {};

        # Screenshots
        "Print".action.screenshot = {};
        "Ctrl+Print".action.screenshot-screen = {};
        "Alt+Print".action.screenshot-window = {};

        # System
        "Mod+Shift+P".action.power-off-monitors = {};
        "Mod+Escape" = { allow-inhibiting = false; action.toggle-keyboard-shortcuts-inhibit = {}; };
      };
    };
  };
}
