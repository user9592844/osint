{
  services.tor.enable = true;
  services.resolved.enable = false;
  networking.nameservers = [ "127.0.0.1" ];
  networking.firewall.allowedTCPPorts = [
    9050
    9051
  ];
}
