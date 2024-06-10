{

  description = "system flake or something ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {self, nixpkgs, ...}@inputs: {

    nixosConfigurations.vim = nixpkgs.lib.nixosSystem{

      specialArgs = {inherit inputs;};
      system = "x86_64-linux";

      modules = [ ./configuration.nix ];

    };

  };

}
