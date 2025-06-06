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
 ./riverwm.nix
 ];
  options = {
  localeTime.enable = lib.mkDefault true;
  };
}

