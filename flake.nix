{
  description = "Home Manager-based setup for non-NixOS machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Spicetify: for prettifying Spotify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix }:
    # Helper function for building the same home environment but with or without nvidia GPU
    let
      mkHome = { nvidia ? false }: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          } // (if nvidia then { nvidia.acceptLicense = true; } else {});
        };
        extraSpecialArgs = { inherit spicetify-nix; };
        modules = [ ./home.nix ] ++ (if nvidia then [ ./nvidia.nix ] else []);
      };
    in
    {
      homeConfigurations = {
        laptop = mkHome { };
        pc = mkHome { nvidia = true; };
      };
    };
}
