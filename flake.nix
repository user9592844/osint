{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, sops-nix, disko }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;

      inherit (nixpkgs) lib;
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit configLib nixpkgs; };
    in {
      packages =
        forEachSupportedSystem (system: nixpkgs.legacyPackages."${system}");

      nixosConfigurations = {
        olympus = lib.nixosSystem {
          inherit specialArgs;
          modules = [ disko.nixosModules.disko ./modules ];
        };
      };
    };
}
