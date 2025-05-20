{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
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

  outputs = { self, nixpkgs, ... }: {
  # outputs = { self, nixpkgs, unstable, ... }: {
  # outputs = { self, nixpkgs, unstable, qtileflake, ... }: {
    nixosConfigurations.zuki = nixpkgs.lib.nixosSystem {
        specialArgs = { 
            # inherit unstable;
        };
        modules = [
        # (_: { nixpkgs.overlays = [ qtileflake.overlays.default ]; })
        ./configuration.nix
        ];
    };
  };
}
