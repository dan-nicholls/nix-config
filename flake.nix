{
  description = "Dans Multi-host Home Manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

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

    nvf = {
      url = "github:notashelf/nvf/v0.8";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprlock.url = "github:hyprwm/hyprutils";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixGL,
    zen-browser,
    nvf,
    hyprland,
    hyprlock,
    ...
  }: let
    system = "x86_64-linux";
    zenVariant = "twilight";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };

    nixglPkgs = nixGL.packages.${system};
    zenPackages = zen-browser.packages.${system};
    hyprlandPkgs = hyprland.packages.${system};
    hyprlockPkgs = hyprlock.packages.${system};
  in {
    homeConfigurations = {
      laptop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/common
          ./modules/hosts/laptop.nix
        ];

        extraSpecialArgs = {
          hostRole = "laptop";
          deviceName = "x1-carbon";
          nixglPkgs = nixglPkgs;
          zenModule = zen-browser.homeModules.${zenVariant};
          zenVariant = zenVariant;
          zenPackages = zenPackages;
          nvfHomeModule = nvf.homeManagerModules.default;
          hyprlandPkgs = hyprlandPkgs;
          hyprlockPkgs = hyprlockPkgs;
        };
      };

      desktop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/common
          ./modules/hosts/desktop.nix
        ];

        extraSpecialArgs = {
          hostRole = "desktop";
          deviceName = "dans-pc";
          zenModule = zen-browser.homeModules.${zenVariant};
          zenVariant = zenVariant;
          zenPackages = zenPackages;
          nixglPkgs = nixglPkgs;
          nvfHomeModule = nvf.homeManagerModules.default;
        };
      };
    };
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
