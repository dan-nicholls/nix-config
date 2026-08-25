{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.desktop = {pkgs, ...}: {
    imports = [
      self.nixosModules.hyprland
      self.nixosModules.noctalia
      self.nixosModules.noctaliaGreeter
      self.nixosModules.lidScripts
    ];
  };
}
