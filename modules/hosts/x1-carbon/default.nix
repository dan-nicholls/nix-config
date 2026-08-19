{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.x1-carbon = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.x1-carbonConfiguration
      self.nixosModules.tmux
      self.nixosModules.hyprland
      self.nixosModules.nvim
    ];
  };
}
