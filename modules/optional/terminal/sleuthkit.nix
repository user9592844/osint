{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.sleuthkit ];
}
