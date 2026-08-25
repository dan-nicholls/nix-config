{...}: let
  settings = builtins.fromTOML (builtins.readFile ./settings.toml);
in {
  services.walker.enable = true;
  services.walker.systemd.enable = true;
  services.walker.settings = settings;
}
