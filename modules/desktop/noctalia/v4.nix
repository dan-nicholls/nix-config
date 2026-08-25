{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    noctaliaV4 = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings =
        (builtins.fromJSON (builtins.readFile ./v4-settings.json)).settings;
    };
  in {
    packages = {
      inherit noctaliaV4;
      myNoctalia = noctaliaV4;
    };
  };
}
