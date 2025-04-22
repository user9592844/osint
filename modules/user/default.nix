{ pkgs, lib, ...}: {
  users = {
    mutableUsers = false;

    users = {
      harpocrates = {
        home = "/home/harpocrates";
        isNormalUser = true;
        password = "hunter2";

        extraGroups = [ "wheel" "networkmanager" ];

        shell = pkgs.bash; # Default shell
      };
    };
  };
}
