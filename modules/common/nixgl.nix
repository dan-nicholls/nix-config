{
  lib,
  nixglPkgs,
  ...
}: {
  targets.genericLinux.nixGL.packages = lib.mkDefault nixglPkgs;
}
