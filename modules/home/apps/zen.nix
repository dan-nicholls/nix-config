{
  config,
  lib,
  zenModule,
  zenPackages,
  zenVariant,
  ...
}: let
  wrapWithNixGL = config.lib ? nixGL && config.lib.nixGL ? wrap;
  basePackage = zenPackages.${zenVariant};
  zenPackage =
    if wrapWithNixGL
    then config.lib.nixGL.wrap basePackage
    else basePackage;
in {
  imports = [zenModule];

  programs.zen-browser = {
    enable = true;
    package = lib.mkOverride 900 zenPackage;
  };
}
