{ lib, nixglPkgs, ... }: {
  nixGL.packages = lib.mkDefault nixglPkgs;
}
