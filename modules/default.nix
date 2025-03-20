{ lib, configLib, ... }: {
  imports = [ ./hardware-configuration.nix ./disko-config.nix ]
    ++ (map configLib.relativeToRoot [
      # Core Modules (DO NOT REMOVE)
      "modules/core"

      # Optional Modules
      "modules/optional/browser/firefox.nix"

      # Create User Profile
      "modules/user"
    ]);

  disko.devices.disk.main.device = "/dev/sda";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      # timeout = 3;
    };

    blacklistedKernelModules = [ "firewire-core" "thunderbolt" ];
  };

  networking = {
    hostName = "olympus";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = false;
      logRefusedConnections = true;
      logRefusedPackets = true;

      # Only allow inbound traffic on ports specified here
      # NOTE: This does not affect outbound traffic
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  system.stateVersion = "24.11";
}
