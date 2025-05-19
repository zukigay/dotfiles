{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nix-search = {
        url = "github:diamondburned/nix-search";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.zuki = nixpkgs.lib.nixosSystem {
        modules = [
        ./configuration.nix
        ];
    };
  };
}
