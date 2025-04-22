{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.amass ];
}
