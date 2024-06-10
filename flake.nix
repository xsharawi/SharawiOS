{

  description = "system flake or something ig";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {self, nixpkgs, ...}: {

    nixosConfigurations.vim = nixpkgs.lib.nixosSystem{

      system = "x86_64-linux";

      modules = [ ./configuration.nix ];

    };

  };

}
