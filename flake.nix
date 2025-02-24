{

  description = "system flake or something ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    #xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {

      nixosConfigurations.vim = nixpkgs.lib.nixosSystem {

        specialArgs = { inherit inputs; };
        system = "x86_64-linux";

        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          inputs.stylix.nixosModules.stylix
        ];

      };

    };

}
