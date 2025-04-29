{ config, pkgs, nixglPkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    gnomeExtensions.power-tracker
    gnome-extension-manager
	discord
	spotify
  ];

  nixGL.packages = nixglPkgs;
  #nixGL.defaultWrapper = "mesa";

  programs.ghostty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.ghostty);
    settings = {
      theme = "GruvboxDark";
	  background-opacity = 0.9;
    };
  };

  dconf.settings = {
    # Swap caps and escape in GNOME
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:swapescape" ];
    };

    # Enable extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
	"marcs14@gmail.com"
      ];

      favorite-apps = [
        "ubuntu-desktop-bootstrap_ubuntu-desktop-bootstrap.desktop"
        "firefox_firefox.desktop"
        "org.gnome.Nautilus.desktop"
	"com.mitchellh.ghostty.desktop"
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
	"switch-to-workspace-1" = [ "<Super>1" ];
	"switch-to-workspace-2" = [ "<Super>2" ];
	"switch-to-workspace-3" = [ "<Super>3" ];
	"switch-to-workspace-4" = [ "<Super>4" ];
		
	# Move Windows
	"move-to-workspace-1" = [ "<Shift><Super>1" ];
	"move-to-workspace-2" = [ "<Shift><Super>2" ];
	"move-to-workspace-3" = [ "<Shift><Super>3" ];
	"move-to-workspace-4" = [ "<Shift><Super>4" ];
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
