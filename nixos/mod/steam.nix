{config, lib,pkgs, ...}:
{
 options = {
    mod-steam.enable = lib.mkEnableOption "setup steam";
 };
 config = lib.mkIf config.mod-steam.enable {
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        extest.enable = true;
    };
    programs.steam.extraPackages = with pkgs; [
    adwaita-icon-theme
    # wine
    # wine64
    ];
 };

}
