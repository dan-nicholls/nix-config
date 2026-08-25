{
  description = "nixOS configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [
        ./modules/hosts/x1-carbon/default.nix
        ./modules/hosts/x1-carbon/configuration.nix
        ./modules/hosts/x1-carbon/hardware-configuration.nix
        ./modules/desktop/hyprland/lid.nix
        ./modules/desktop/hyprland/hyprland.nix
        ./modules/desktop/greeters/tuigreet.nix
        ./modules/desktop/greeters/noctalia-greeter.nix
        ./modules/apps/tmux.nix
        ./modules/apps/nvf.nix
        ./modules/desktop/apps/zen.nix
        ./modules/desktop/niri/niri.nix
        ./modules/desktop/noctalia
        ./modules/common/dev.nix
        ./modules/desktop/apps/ghostty.nix
        ./modules/common/caps-swap-tty.nix
      ];
    };
  #(inputs.import-tree ./modules);
}
