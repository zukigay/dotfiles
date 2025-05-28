{ config, lib, pkgs, volare, ... }:
{
  options = {
    # mod-scrollpkg.enable = 
    # 	lib.mkEnableOption "install the scrollwm";
    # mod-replace-sway-with-scroll.enable = 
    # 	lib.mkEnableOption "replace the sway pkg with scroll";
    mod-volare.enable = 
    	# lib.mkEnableOption "install the scrollwm";
    	lib.mkEnableOption "replace the sway pkg with volare";
  };
  # config = lib.mkIf config.mod-scroll.enable {
  #   environment.systemPackages = [ scroll ]; };
  config = lib.mkIf config.mod-volare.enable {
        programs.sway = {
        package = pkgs.sway.override {
          sway-unwrapped = volare.packages.x86_64-linux.default;
          
        };
    };
  };

}
