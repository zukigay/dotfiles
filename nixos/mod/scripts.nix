{config, lib,pkgs, ...}:
{
 options = {
    mod-scripts.enable = lib.mkEnableOption "add scripts to path and add common script utilities";
 };
 config = lib.mkIf config.mod-scripts.enable {
    environment.sessionVariables = {
        PATH = [ 
          "$HOME/.scripts"
        ];
    };
    environment.systemPackages = with pkgs; [
        jq
        xorg.xprop
        python3
        libnotify
        inotify-tools
    ];
 };
}
