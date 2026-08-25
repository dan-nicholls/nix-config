{
  inputs,
  ...
}: {
  perSystem = {system, ...}: {
    packages.noctaliaV5 =
      inputs.nixpkgs-unstable.legacyPackages.${system}.noctalia;
  };
}
