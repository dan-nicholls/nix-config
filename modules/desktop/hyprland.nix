{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: let
    noctalia = self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia;
    wallpaper = ../../assets/backgrounds/2-forest.jpg;
  in {
    programs.hyprland = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
    };

    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    environment.systemPackages = [pkgs.hyprpaper noctalia];

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
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myHyprland = inputs.wrapper-modules.lib.wrapPackage ({...}: {
      inherit pkgs;

      package = pkgs.hyprland;
      flags."--config" = "${./hyprland.lua}";

      passthru.providedSessions = pkgs.hyprland.passthru.providedSessions;
    });
  };
}
