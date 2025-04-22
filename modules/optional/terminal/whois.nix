{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.whois ];
}
