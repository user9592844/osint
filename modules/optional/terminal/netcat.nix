{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.netcat ];
}
