{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];

  dconf.settings = {
    # Swap caps and escape in GNOME
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };

    # Disable dynamic workspaces
    "org/gnome/mutter" = {
	dynamic-workspaces = false;
    };

    # Set workspaces to 4
    "org/gnome/desktop/wm/preferences" = {
	num-workspaces = 4;
    };

    # Disable Super + [1..4]
    "org/gnome/shell/keybindings" = {
	"switch-to-application-1" = [];
	"switch-to-application-2" = [];
	"switch-to-application-3" = [];
	"switch-to-application-4" = [];
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
	"app-hotkey-1" = [];
	"app-hotkey-2" = [];
	"app-hotkey-3" = [];
	"app-hotkey-4" = [];
   };

    "org/gnome/desktop/wm/keybindings" = {
	"switch-to-workspace-1" = [ "<Super>1" ];
	"switch-to-workspace-2" = [ "<Super>2" ];
	"switch-to-workspace-3" = [ "<Super>3" ];
	"switch-to-workspace-4" = [ "<Super>4" ];
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
