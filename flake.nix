{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, disko, ... }:
    let
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;

      inherit (nixpkgs) lib;
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit configLib nixpkgs; };
    in
    {

      nixosConfigurations = {
        olympus = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ({ nixpkgs, ... }: {
              imports = [
                "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ];
            })
            disko.nixosModules.disko
            ./modules

          ];
        };
      };

      packages = forEachSupportedSystem (system:
        let
          pkgs = nixpkgs.legacyPackages."${system}";
          iso = self.nixosConfigurations.olympus.config.system.build.isoImage;

          # Find the ISO files in the build output directory, and if only one grab the name
          isoDirFiles = builtins.attrNames (builtins.readDir "${iso}/iso");
          isoFile =
            let
              isoFiles =
                builtins.filter (name: builtins.match ".*\\.iso$" name != null)
                  isoDirFiles;
              numIsoFiles = builtins.length isoFiles;
            in
            if numIsoFiles == 1 then
              builtins.head isoFiles
            else
              throw "Expected exactly one ISO file in ${iso}/iso";

          isoHash = builtins.hashFile "sha256" "${iso}/iso/${isoFile}";
          commitHash = self.rev or "dirty";
        in
        {
          default = pkgs.stdenv.mkDerivation {
            name = "iso-with-metadata";

            src = iso;

            buildPhase = ''
              mkdir -p $out

              # Copy ISO
              cp ${iso}/iso/*.iso $out/

              cat > $out/version.txt <<EOF
              ISO Build Info
              ==============
              Git Commit: ${commitHash}
              SHA256: sha256-${isoHash}
              EOF
            '';
          };
        });
    };
}
