{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
        inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # unstable.url = "nixpkgs/nixos-unstable";
    # qtileflake = {
    #     # url = "github:qtile/qtile";
    #     url = "github:qtile/qtile/v0.31.0";
    #     # inputs.nixpkgs.follows = "nixpkgs";
    #     inputs.nixpkgs.follows = "unstable";
    # };
    # qtileflake = {
       # url = "github:qtile/qtile";
       # inputs.nixpkgs.follows = "nixpkgs";
       #  url = "github:qtile/qtile/v0.31.0";
        # url = "github:jwijenbergh/qtile/wayc";
        # inputs.nixpkgs.follows = "unstable";
     # };

    # nix-search = {
    #     url = "github:diamondburned/nix-search";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # outputs = { self, nixpkgs, unstable, ... }: {
  # outputs = { self, nixpkgs, unstable, qtileflake, ... }: 
  outputs = { self, nixpkgs,  volare, ... }: 
  let
    # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    system = "x86_64-linux";
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
  in {
    nixosConfigurations.zuki = nixpkgs.lib.nixosSystem {
        specialArgs = { 
            # inherit pkgs-unstable;
            inherit pkgs-stable;
        };
        modules = [
        # (_: { nixpkgs.overlays = [ qtileflake.overlays.default ]; })
        ./configuration.nix
        ];
    };
  };
}
