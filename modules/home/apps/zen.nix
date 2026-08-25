{
  lib,
  zenModule,
  zenPackages,
  zenVariant,
  ...
}: {
  imports = [zenModule];

  programs.zen-browser = {
    enable = true;
    package = lib.mkOverride 900 zenPackages.${zenVariant};
  };
}
