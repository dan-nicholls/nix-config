{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.noctalia = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia
      (pkgs.writeShellScriptBin "noctalia-command" ''
        case "$1" in
          start) exec noctalia ;;
          launcher) exec noctalia msg panel-toggle launcher ;;
          lock) exec noctalia msg session lock ;;
          *) exit 2 ;;
        esac
      '')
    ];
  };

  perSystem = {system, ...}: {
    packages.noctalia =
      inputs.nixpkgs-unstable.legacyPackages.${system}.noctalia;
  };
}
