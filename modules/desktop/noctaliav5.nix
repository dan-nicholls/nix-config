{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.noctaliaV5 = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.noctaliaV5
    ];
  };

  perSystem = {system, ...}: {
    packages.noctaliaV5 =
      inputs.nixpkgs-unstable.legacyPackages.${system}.noctalia;
  };
}
