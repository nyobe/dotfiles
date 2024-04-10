{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    mkHome = system: extraModules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        # pass flake inputs as extra argument to home modules
        extraSpecialArgs = {inherit inputs;};
        # always include the base home module
        modules = [./home.nix] ++ extraModules;
      };
  in {
    lib = {inherit mkHome;};
    templates = import ./templates;

    homeConfigurations."turntide@newpkins" = mkHome "x86_64-darwin" [
      {home.username = "turntide";}
    ];

    homeConfigurations."nyobe@m1ttens" = mkHome "aarch64-darwin" [];

    formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.alejandra;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
  };
}
