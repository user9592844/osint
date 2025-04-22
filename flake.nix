{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    sops-nix.url = "github:Mic92/sops-nix";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, sops-nix, disko}:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;

      inherit (nixpkgs) lib;
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit configLib nixpkgs; };
      gitRev = self.rev or "dirty";
    in {
      packages = forEachSupportedSystem (system:
        let pkgs = nixpkgs.legacyPackages."${system}";
        in {
          inherit pkgs;
          default = self.nixosConfigurations.olympus.config.system.build.isoImage;

          checksum = pkgs.writeText "iso-checksum.txt" ''
            ISO Build Info
            ===============
            Git Commit: ${gitRev}
            SHA256: $(sha256sum ${self.nixosConfigurations.olympus.config.system.build.isoImage}/iso/*.iso | awk '{print $1}')
          '';
        });

      nixosConfigurations = {
        olympus = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({nixpkgs, ...}: {
              imports = [ "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix" ];
              environment.etc."iso-info.txt".text = ''
                Git Commit: ${gitRev}
              '';
            })
            disko.nixosModules.disko
            ./modules

          ];
        };
      };
    };
}
