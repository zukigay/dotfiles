{
  pkgs ? import <nixpkgs> { },
}:
let
  wlroots_0_19-c = pkgs.wlroots_0_18.overrideAttrs (finalAttrs: previousAttrs: {
    version = "0.19";
    # pname = "wlroots";
    src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        # rev = "0.19";
        rev = finalAttrs.version;
        hash = "sha256-I8z50yA/ukvXEC5TksG84+GrQpfC4drBJDRGw0R8RLk=";
    };
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
    # nativeBuildInputs = [
        # pkgs.wayland
  #       # unstable.wayland-protocols
  #       # unstable.wayland-utils
    ];

  });

in
pkgs.callPackage (
  {
    mkShell,
  libX11,
  libinput,
  libxcb,
  libxkbcommon,
  pixman,
  pkg-config,
  stdenv,
  testers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xcbutilwm,
  xwayland,
  }:
  mkShell {
    strictDeps = true;
    # host/target agnostic programs
    depsBuildBuild = [
    ];
    # compilers & linkers & dependecy finding programs
    nativeBuildInputs = [
    pkg-config
    wayland-scanner
    ];
    # libraries
    buildInputs = [
          libinput
      libxcb
      libxkbcommon
      pixman
      wayland
      wayland-protocols
      wlroots_0_19-c
      wayland-scanner
      # xwayland
      libX11
      xcbutilwm
      xwayland
    ];
  }
) { }

