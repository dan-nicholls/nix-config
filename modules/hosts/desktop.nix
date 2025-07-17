{ config, pkgs, lib, nixglPkgs, deviceName ? "desktop", ... }:

{
	nixGL.packages = nixglPkgs;

	programs.ghostty = {
		enable = true;
		package = (config.lib.nixGL.wrap pkgs.ghostty);
		settings = {
			theme = "GruvboxDark";
			background-opacity = 0.9;
			font-family = "Terminess Nerd Font Mono";
			font-size = 15;
		};
	};

	home.packages = with pkgs; [
		terminus-nerdfont
	];
}
