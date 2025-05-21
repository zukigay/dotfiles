{ config, lib, pkgs, ... }:
let
  wlroots_0_20-git = pkgs.wlroots_0_18.overrideAttrs (finalAttrs: previousAttrs: {
    version = "0.20";
    # pname = "wlroots";
    src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        # rev = "0.19";
        rev = "170f7e070603f0ecdadc4527c65bc08b62073e58";
        hash = "sha256-SMzz7J05LocbC7ROhScwPzhnh/l0rzCPMWN5owkwZ5Q=";
    };
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
    # nativeBuildInputs = [
        # pkgs.wayland
  #       # unstable.wayland-protocols
  #       # unstable.wayland-utils
    ];

  });

scroll = pkgs.sway-unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
    src = pkgs.fetchFromGitHub {
        owner = "dawsers";
        repo = "scroll";
        rev = "515f638f0a0616f684a3ece29a56bd735b87350b";
        hash = "sha256-rktayVLLxVjtzBpYVvoeMRma2B4VfmvCevlLTCaf4Y4=";
    };
    patches = [];
    buildInputs = previousAttrs.buildInputs ++ [ wlroots_0_20-git ];
});
in
{
config.environment.systemPackages = [
scroll
];
}
