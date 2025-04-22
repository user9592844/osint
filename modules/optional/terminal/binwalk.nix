{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.binwalk ];
}
