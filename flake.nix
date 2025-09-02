{
  description = "Dans Multi-host Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixGL,
    zen-browser,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };

    nixglPkgs = nixGL.packages.${system};
  in {
    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/common/home.nix
          ./modules/common/dev.nix
          ./modules/common/shell.nix
          ./modules/hosts/laptop.nix
        ];

        extraSpecialArgs = {
          hostRole = "laptop";
          deviceName = "x1-carbon";
          nixglPkgs = nixglPkgs;
          zenModule = zen-browser.homeModules.twilight;
        };
      };

      desktop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/common/home.nix
          ./modules/common/dev.nix
          ./modules/common/shell.nix
          ./modules/hosts/desktop.nix
        ];

        extraSpecialArgs = {
          hostRole = "desktop";
          deviceName = "dans-pc";
          zenModule = zen-browser.homeModules.twilight;
          nixglPkgs = nixglPkgs;
        };
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
