{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, niri-flake, nix-cachyos-kernel, dms, nixvim, ... }:
  let
    commonHomeModules = [
      niri-flake.homeModules.niri
      dms.homeModules.dank-material-shell
      nixvim.homeModules.nixvim
      ./home
    ];
  in {
    nixosConfigurations.radish = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ]; }
        ./hosts/radish/configuration.nix
      ];
    };

    nixosConfigurations.onion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
	{ nixpkgs.overlays = [ nix-cachyos-kernel.overlays.default ]; }
        ./hosts/onion/configuration.nix
      ];
    };

    homeConfigurations.leo = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonHomeModules;
    };

    homeConfigurations.leo-radish = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonHomeModules ++ [ ./hosts/radish/home.nix ];
    };

    homeConfigurations.leo-onion = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = commonHomeModules ++ [ ./hosts/onion/home.nix ];
    };
  };
}
