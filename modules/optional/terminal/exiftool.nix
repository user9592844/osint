{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.exiftool ];
}
