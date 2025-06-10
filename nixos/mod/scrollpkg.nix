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
        rev = "af43d3b9e7017d915dffe7bdeccea3adb8155774";
        hash = "sha256-U3SIs9rd3bQKP8A+kJopaQ5NfYadLJC/Hfl81R7zgV4=";
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
        rev = "8702a2d559ef73860e902fbc1bddb0efa60eb05d";
        hash = "sha256-MyOd3xKSCueEpPStuIsLJlp2kDl4biikyWACBD2ufx8=";
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
