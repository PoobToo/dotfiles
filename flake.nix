{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";

  };

  outputs = { self, nixpkgs, home-manager, niri-flake, dms, ... }: {
    nixosConfigurations.radish = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/radish/configuration.nix
      ];
    };

    nixosConfigurations.onion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/onion/configuration.nix
      ];
    };

    homeConfigurations.leo = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        niri-flake.homeModules.niri
        dms.homeModules.dank-material-shell
        ./home.nix
      ];
    };
  };
}
