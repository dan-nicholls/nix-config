{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.ghostty = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      ghostty
    ];
  };
}
