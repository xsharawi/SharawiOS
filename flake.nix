{

  description = "system flake or something ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, ...}@inputs: {

    nixosConfigurations.vim = nixpkgs.lib.nixosSystem{

      specialArgs = {inherit inputs;};
      system = "x86_64-linux";

      modules = [ 
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];

    };

  };

}
