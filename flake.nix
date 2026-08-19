{
  description = "nixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./modules/hosts/x1-carbon/default.nix
        ./modules/hosts/x1-carbon/configuration.nix
        ./modules/hosts/x1-carbon/hardware-configuration.nix
        ./modules/desktop/niri.nix
        ./modules/desktop/noctalia.nix
      ];
    };
  #(inputs.import-tree ./modules);
}
