{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.hashcat ];
}
