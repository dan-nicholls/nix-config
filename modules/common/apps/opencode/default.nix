{inputs, ...}: {
  flake.nixosModules.opencode = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.opencode;
    skillsDirectory = ./skills;
    skillEntries = builtins.readDir skillsDirectory;
    skillNames = lib.filter (
      name: skillEntries.${name} == "directory" && builtins.pathExists (skillsDirectory + "/${name}/SKILL.md")
    ) (builtins.attrNames skillEntries);
    skillRules = map (
      name: "L+ /home/${cfg.user}/.config/opencode/skills/${name} - - - - ${skillsDirectory}/${name}"
    ) skillNames;
  in {
    options.programs.opencode = {
      enable = lib.mkEnableOption "OpenCode";

      package = lib.mkOption {
        type = lib.types.package;
        default = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode;
        description = "OpenCode package to install.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "User whose global OpenCode configuration receives managed skills.";
      };

      skills = lib.mkEnableOption "skills from modules/common/apps/opencode/skills";
    };

    config = lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.skills -> config.users.users ? ${cfg.user};
          message = "programs.opencode.user must name a declared NixOS user when managed skills are enabled.";
        }
      ];

      environment.systemPackages = [cfg.package];

      systemd.tmpfiles.rules = lib.optionals cfg.skills ([
        "d /home/${cfg.user}/.config/opencode 0755 ${cfg.user} users -"
        "d /home/${cfg.user}/.config/opencode/skills 0755 ${cfg.user} users -"
      ] ++ skillRules);
    };
  };
}
