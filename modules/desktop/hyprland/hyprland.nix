{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: let
    wallpaper = ../../../assets/backgrounds/2-forest.jpg;
  in {
    programs.hyprland = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myHyprland;
    };

    #programs.hyprlock.enable = true;
    #services.hypridle.enable = true;

    services.logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    environment.systemPackages = [
      pkgs.hyprpaper
      pkgs.bibata-cursors
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      HYPRCURSOR_THEME = "Bibata-Modern-Classic";
      HYPRCURSOR_SIZE = "28";
      XCURSOR_THEME = "Bibata-Modern-Classic";
      XCURSOR_SIZE = "28";
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
