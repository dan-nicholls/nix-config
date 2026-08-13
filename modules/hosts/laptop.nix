{
  config,
  pkgs,
  deviceName ? "x1-carbon",
  ...
}: {
  imports = [
    ../apps/ghostty.nix
    ../apps/zen.nix
    ../common/nixgl.nix
    ../apps/hyprland.nix
  ];

  home.packages = with pkgs; [
    rofi
    gnomeExtensions.power-tracker
    gnome-extension-manager
    spotifyd
    discord
    nerd-fonts.jetbrains-mono
    nerd-fonts.terminess-ttf
    deskflow
    tailscale
    lan-mouse
    obsidian
    localsend
  ];

  programs.ghostty.settings.theme = "Gruvbox Dark";

  programs.anki = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.anki;
  };

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        backend = "pulseaudio";
        device_name = deviceName;
      };
    };
  };

  programs.spotify-player = {
    enable = true;
    settings = {
      default_device = deviceName;
      client_id = "289a79b3f16449f4a3b97fb2bd357d93";
      enable_streaming = "Never";
    };
  };

  systemd.user.services.rode-ai1-profile = {
    Unit = {
      Description = "Keep RODE AI-1 in duplex Pro Audio mode";
      After = ["wireplumber.service"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "rode-ai1-profile" ''
        status=$(/usr/bin/wpctl status -n)
        source_id=$(sed -n 's/^[^0-9]*\([0-9]\+\)\. alsa_input\.usb-RODE_Microphones_RODE_AI-1_4C07E762-00\.pro-input-0 .*$/\1/p' <<< "$status")
        if [[ -z "$source_id" ]]; then
          device_id=$(sed -n 's/^[^0-9]*\([0-9]\+\)\. alsa_card\.usb-RODE_Microphones_RODE_AI-1_4C07E762-00 .*$/\1/p' <<< "$status")
          if [[ -n "$device_id" ]]; then
            /usr/bin/wpctl set-profile "$device_id" 3
            sleep 1
            status=$(/usr/bin/wpctl status -n)
            /usr/bin/wpctl set-default "$(sed -n 's/^[^0-9]*\([0-9]\+\)\. alsa_input\.usb-RODE_Microphones_RODE_AI-1_4C07E762-00\.pro-input-0 .*$/\1/p' <<< "$status")"
            /usr/bin/wpctl set-default "$(sed -n 's/^[^0-9]*\([0-9]\+\)\. alsa_output\.usb-RODE_Microphones_RODE_AI-1_4C07E762-00\.pro-output-0 .*$/\1/p' <<< "$status")"
          fi
        fi
      '';
    };
  };

  systemd.user.timers.rode-ai1-profile = {
    Unit.Description = "Check RODE AI-1 audio profile";
    Timer = {
      OnBootSec = "2s";
      OnUnitActiveSec = "5s";
      Unit = "rode-ai1-profile.service";
    };
    Install.WantedBy = ["timers.target"];
  };

  dconf.settings = {
    # Swap caps and escape in GNOME
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape"];
    };

    # Enable extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "marcs14@gmail.com"
      ];

      favorite-apps = [
        "ubuntu-desktop-bootstrap_ubuntu-desktop-bootstrap.desktop"
        "zen.desktop"
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
        "spotify.desktop"
        "discord.desktop"
      ];
    };

    # Disable dynamic workspaces
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    # Set workspaces to 4
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 4;
    };

    # Disable GNOME Super + [1..4]
    "org/gnome/shell/keybindings" = {
      "switch-to-application-1" = [];
      "switch-to-application-2" = [];
      "switch-to-application-3" = [];
      "switch-to-application-4" = [];
    };

    # Disable Dash-To-Dock Super + [1..4] Bindings
    "org/gnome/shell/extensions/dash-to-dock" = {
      "app-hotkey-1" = [];
      "app-hotkey-2" = [];
      "app-hotkey-3" = [];
      "app-hotkey-4" = [];
      "app-shift-hotkey-1" = [];
      "app-shift-hotkey-2" = [];
      "app-shift-hotkey-3" = [];
      "app-shift-hotkey-4" = [];

      "dock-position" = "BOTTOM";
      "autohide" = true;
      "show-trash" = false;
      "extend-height" = false;
    };

    # Set workspace bindings
    "org/gnome/desktop/wm/keybindings" = {
      # Switch Workspaces
      "switch-to-workspace-1" = ["<Super>1"];
      "switch-to-workspace-2" = ["<Super>2"];
      "switch-to-workspace-3" = ["<Super>3"];
      "switch-to-workspace-4" = ["<Super>4"];

      # Move Windows
      "move-to-workspace-1" = ["<Shift><Super>1"];
      "move-to-workspace-2" = ["<Shift><Super>2"];
      "move-to-workspace-3" = ["<Shift><Super>3"];
      "move-to-workspace-4" = ["<Shift><Super>4"];
    };

    # Set rofi keybinds
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi" = {
      name = "Launch Rofi";
      command = "rofi -show drun";
      binding = "<Super>r";
    };
  };
}
