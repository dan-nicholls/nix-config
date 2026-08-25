{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.x1-carbon = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.x1-carbonConfiguration
      self.nixosModules.desktop
      self.nixosModules.devTools
      self.nixosModules.ghostty
      self.nixosModules.zen
      self.nixosModules.capsEscSwap
    ];
  };
}
