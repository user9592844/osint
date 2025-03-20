{ configLib, ... }: {
  imports = (configLib.scanPaths ./.);
  nixpkgs.config.allowUnfree = true;
}
