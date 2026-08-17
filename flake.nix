{
  description = "nixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nvf,
    ...
  }: {
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nvf.nixosModules.default
        ./modules/hosts/x1-carbon/configuration.nix
        ./modules/apps/tmux.nix
        ./modules/common/caps-swap-tty.nix
        ./modules/apps/nvf.nix
      ];
    };
  };
}
