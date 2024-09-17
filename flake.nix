{

  description = "system flake or something ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations.vim = nixpkgs.lib.nixosSystem {

      specialArgs = { inherit inputs; };
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];

    };

  };

}
