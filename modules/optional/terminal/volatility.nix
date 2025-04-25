{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.volatility3 ];
}
