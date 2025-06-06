{config, lib,pkgs, ...}:
{
 options = {
    mod-riverwm.enable = lib.mkEnableOption "enable all the basic stuff needed for my river setup";
 };
 config = lib.mkIf config.mod-riverwm.enable {
    programs.river.enable = true;
    programs.river.extraPackages = with pkgs; [ 
      # kitty 
      foot
      waybar 
      fuzzel 
      lua5_3 
      river-luatile 
      hyprpaper 
      slurp 
      grim 


      lswt

      # xrandr for setting a monitor as --primary
      # so that steam games won't cap the res
      # at the lowist active monitor.
      xorg.xrandr

      # for notifcations
      dunst
      libnotify

      # to set monitors up
      wlr-randr
      kanshi

      # lock program of choice
      swaylock
      swayidle
    ];
 };
}
