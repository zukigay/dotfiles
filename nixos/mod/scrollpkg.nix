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
        rev = "1171c7dbef18e766d8c7131834720a7f5824ed8f";
        hash = "sha256-QzOUYONfg5iG3+/P1UiTOyqWZLF5lXnRjN3ROugX97Y=";
    };
    passthru.providedSessions = [ "scroll" ];
    patches = [];
    buildInputs = previousAttrs.buildInputs ++ [ wlroots_0_20-git ];
});
in
{
  options = {
    # mod-scrollpkg.enable = 
    # 	lib.mkEnableOption "install the scrollwm";
    # mod-replace-sway-with-scroll.enable = 
    # 	lib.mkEnableOption "replace the sway pkg with scroll";
    mod-scroll.enable = 
    	# lib.mkEnableOption "install the scrollwm";
    	lib.mkEnableOption "replace the sway pkg with scroll";
  };
  # config = lib.mkIf config.mod-scroll.enable {
  #   environment.systemPackages = [ scroll ]; };
  config = lib.mkIf config.mod-scroll.enable {
    programs.sway.package = scroll;
  };

}
