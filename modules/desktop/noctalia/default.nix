{
  self,
  ...
}: {
  imports = [
    ./v4.nix
    ./v5.nix
  ];

  flake.nixosModules.noctalia = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.desktop.noctalia;
    system = pkgs.stdenv.hostPlatform.system;

    versions = {
      v4 = {
        package = self.packages.${system}.noctaliaV4;
        commands = {
          start = "noctalia-shell";
          launcher = "noctalia-shell ipc call launcher toggle";
          lock = "noctalia-shell ipc call lockScreen lock";
        };
      };

      v5 = {
        package = self.packages.${system}.noctaliaV5;
        commands = {
          start = "noctalia";
          launcher = "noctalia msg panel-toggle launcher";
          lock = "noctalia msg session lock";
        };
      };
    };

    selected = versions.${cfg.version};
  in {
    options.desktop.noctalia = {
      enable = lib.mkEnableOption "Noctalia desktop shell";

      version = lib.mkOption {
        type = lib.types.enum ["v4" "v5"];
        default = "v4";
        description = "Noctalia major version to use.";
      };

      commands = {
        start = lib.mkOption {
          type = lib.types.str;
          internal = true;
          readOnly = true;
        };

        launcher = lib.mkOption {
          type = lib.types.str;
          internal = true;
          readOnly = true;
        };

        lock = lib.mkOption {
          type = lib.types.str;
          internal = true;
          readOnly = true;
        };
      };
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        selected.package
        (pkgs.writeShellScriptBin "noctalia-command" ''
          case "$1" in
            start) exec ${selected.commands.start} ;;
            launcher) exec ${selected.commands.launcher} ;;
            lock) exec ${selected.commands.lock} ;;
            *) exit 2 ;;
          esac
        '')
      ];

      desktop.noctalia.commands = selected.commands;
    };
  };
}
