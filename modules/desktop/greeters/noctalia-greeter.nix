{
  inputs,
  ...
}: {
  flake.nixosModules.noctaliaGreeter = {pkgs, ...}: {
    imports = [inputs.noctalia-greeter.nixosModules.default];

    programs.noctalia-greeter = {
      enable = true;
      settings = {
        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard.layout = "au";
      };
    };
  };
}
