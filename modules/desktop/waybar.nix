{pkgs, ...}: {
  environment.systemPackages = [pkgs.waybar];

  environment.etc."xdg/waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 28;

    "modules-left" = ["hyprland/workspaces"];
    "modules-center" = ["clock"];
    "modules-right" = ["pulseaudio" "network" "battery"];

    "hyprland/workspaces" = {
      format = "{name}";
      "on-click" = "activate";
    };

    clock.format = "{:%a %d %b  %H:%M}";

    pulseaudio = {
      format = "{volume}% {icon}";
      "format-muted" = "muted";
      "format-icons" = ["low" "mid" "high"];
    };

    network = {
      "format-wifi" = "wifi {signalStrength}%";
      "format-ethernet" = "ethernet";
      "format-disconnected" = "offline";
    };

    battery = {
      format = "{capacity}%";
      "format-charging" = "charging {capacity}%";
    };
  };

  environment.etc."xdg/waybar/style.css".text = ''
    * {
      font-family: monospace;
      font-size: 12px;
      min-height: 0;
    }

    window#waybar {
      background: #1e1e2e;
      color: #cdd6f4;
    }

    #workspaces button,
    #clock,
    #pulseaudio,
    #network,
    #battery {
      padding: 0 8px;
    }

    #workspaces button.active {
      background: #45475a;
    }

    #workspaces button.empty {
      color: #6c7086;
    }
  '';
}
