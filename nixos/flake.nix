{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    # newm = {
        # slower upstream
        # url = "github:newm-next/newm-next";
        # newer downstream
        # url = "github:SEKAMISehi/newm-next";
        # inputs.nixpkgs.follows = "nixpkgs";
    # };
    newm-next.url = "github:newm-next/newm-next";
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
  # outputs = { self, nixpkgs, nixpkgs-stable, newm, ... }: 
  outputs = inputs:
  let
    # pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    system = "x86_64-linux";
    newm = inputs.newm-next.packages.${system}.newm-next.overrideAttrs(_: {
#       postInstall = let
#         newmSession = ''
# [Desktop Entry]
# Name=newm
# Comment=newm
# Exec=start-newm -d
# Type=Application
#         '';
#       in
#         ''
# mkdir -p $out/share/wayland-sessions
# echo "${newmSession}" > $out/share/wayland-sessions/newm.desktop
#         '';
        # passthru.providedSessions = [ "newm" ];
    });
    # pkgs-stable = nixpkgs-stable.legacyPackages.${system};
  in {
    nixosConfigurations.zuki = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { 
            # inherit pkgs-unstable;
            # inherit newm;
            # inherit pkgs-stable;
        };
        modules = [
        # (_: { nixpkgs.overlays = [ qtileflake.overlays.default ]; })
        {environment.systemPackages = [ newm ]; }
        # {services.displayManager.sessionPackages = [ newm ];}
        ./configuration.nix
        ];
    };
  };
}
