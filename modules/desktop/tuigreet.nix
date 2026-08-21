{
  ...
}: {
  flake.nixosModules.tuigreet = {pkgs, ...}: {
    services.greetd = {
      enable = true;

      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd 'start-hyprland -- --config /etc/xdg/hypr/hyprland.lua'";
        user = "greeter";
      };
    };
  };
}
