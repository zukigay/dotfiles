{config, lib, ...}:
# let
# in
{
 imports = [
 ./fonts.nix
 ./steam.nix
 ./wayenv.nix
 ./waynvidiaenv.nix
 ./theme.nix
 ./xdgenv.nix
 ./pathenv.nix
 ./scripts.nix
 ./fixkeyboardservice.nix
 ./hyprPlugins/module.nix
 ./hyprPlugins/plugins/hyprdark.nix
 ./scrollpkg.nix 
 ./volare.nix
 ./vr.nix
 ./heavyEmu.nix
 ./localeTime.nix
 ];
  options = {
    mod-hyprPlugin.enable = 
    	lib.mkEnableOption "enable hyprplugin module which is a tweaked 'nix home module' to work without nix home";
  };
}

