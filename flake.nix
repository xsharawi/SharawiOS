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

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dark-text.url = "github:vimjoyer/dark-text";
    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    nvf,
    dark-text,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    myNVF = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [
        ./nvf.nix
      ];
    };
  in {
    nixosConfigurations.vim = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        inherit nvf;
      };
      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        inputs.stylix.nixosModules.stylix
        nvf.nixosModules.default
      ];
    };
    packages.${system}.vimrawi = myNVF.neovim;
    apps.${system}.vimrawi = {
      type = "app";
      program = "${myNVF.neovim}/bin/nvim";
    };
  };
}
