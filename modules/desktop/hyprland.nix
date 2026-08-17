{pkgs, ...}: let
  wallpaper = ../../assets/backgrounds/2-forest.jpg;
in {
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = [pkgs.hyprpaper];

  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'start-hyprland -- --config /etc/xdg/hypr/hyprland.lua'";
      user = "greeter";
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.etc."xdg/hypr/hyprland.lua".source = ./hyprland.lua;
  environment.etc."xdg/hypr/hyprpaper.conf".text = ''
    splash = false

    wallpaper {
      monitor = *
      path = ${wallpaper}
    }
  '';
}
