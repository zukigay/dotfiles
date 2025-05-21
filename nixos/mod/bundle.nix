{config, lib, ...}:

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
 ];
}

