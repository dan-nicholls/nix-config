{
  description = "nixOS configuration";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { nixpkgs, ... }: {
    nixosConfigurations.x1-carbon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/x1-carbon/configuration.nix
	./modules/apps/tmux.nix
	./modules/common/caps-swap-tty.nix
      ];
    };
  };
}
