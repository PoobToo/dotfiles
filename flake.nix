{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    niri-flake.url = "github:sodiboo/niri-flake";
    niri-flake.inputs.nixpkgs.follows = "nixpkgs";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    dms.url = "github:AvengeMedia/DankMaterialShell/stable";

    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    nixvirt.url = "github:AshleyYakeley/NixVirt";
    nixvirt.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, home-manager, niri-flake, nix-cachyos-kernel, dms, nixvim, nixvirt, ... }:
  let
    commonHomeModules = [
      niri-flake.homeModules.niri
      dms.homeModules.dank-material-shell
      nixvim.homeModules.nixvim
      ./home
    ];

    skipFlakyTestsOverlay = final: prev: {
      openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
    };

    commonOverlays = [
      nix-cachyos-kernel.overlays.default
      skipFlakyTestsOverlay
    ];

    homePkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = commonOverlays;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.radish = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        { nixpkgs.overlays = commonOverlays; }
        ./hosts/radish/configuration.nix
      ];
    };

    nixosConfigurations.onion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inputs = { inherit nixvirt; }; };
      modules = [
        { nixpkgs.overlays = commonOverlays; }
        nixvirt.nixosModules.default
        ./hosts/onion/configuration.nix
      ];
    };

    homeConfigurations.leo = home-manager.lib.homeManagerConfiguration {
      pkgs = homePkgs;
      modules = commonHomeModules;
    };

    homeConfigurations.leo-radish = home-manager.lib.homeManagerConfiguration {
      pkgs = homePkgs;
      modules = commonHomeModules ++ [ ./hosts/radish/home.nix ];
    };

    homeConfigurations.leo-onion = home-manager.lib.homeManagerConfiguration {
      pkgs = homePkgs;
      modules = commonHomeModules ++ [ ./hosts/onion/home.nix ];
    };
  };
}
