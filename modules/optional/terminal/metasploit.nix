{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.metasploit ];
}
