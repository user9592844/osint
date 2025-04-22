{ lib, configLib, ... }: {
  imports = [ ./hardware-configuration.nix ./disko-config.nix ]
    ++ (map configLib.relativeToRoot [
      # Core Modules (DO NOT REMOVE)
      "modules/core"

      # Optional Modules
      "modules/optional/browser/firefox.nix"

      "modules/optional/desktop/gnome-desktop.nix"
      "modules/optional/desktop/vlc.nix"

      "modules/optional/terminal/amass.nix"
      "modules/optional/terminal/bat.nix"
      "modules/optional/terminal/curl.nix"
      "modules/optional/terminal/exiftool.nix"
      "modules/optional/terminal/fd.nix"
      "modules/optional/terminal/ffmpeg.nix"
      "modules/optional/terminal/jq.nix"
      "modules/optional/terminal/lsd.nix"
      "modules/optional/terminal/mat2.nix"
      "modules/optional/terminal/nmap.nix"
      "modules/optional/terminal/ripgrep.nix"
      "modules/optional/terminal/traceroute.nix"
      "modules/optional/terminal/tree.nix"
      "modules/optional/terminal/trippy.nix"
      "modules/optional/terminal/unrar.nix"
      "modules/optional/terminal/unzip.nix"
      "modules/optional/terminal/vim.nix"
      "modules/optional/terminal/wget.nix"
      "modules/optional/terminal/whois.nix"
      "modules/optional/terminal/zip.nix"

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
    wireless.enable = lib.mkForce false;
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

  fileSystems = {
    "/tmp" = {
      fstype = "tmpfs";
      options = [ "mode=1777" "size=512M" ];
    };

    "/var" = {
      fsType = "tmpfs";
      options = [ "mode=0755" "size=512M" ];
    };
  };

  system.stateVersion = "24.11";
}
