{config, lib,pkgs, ...}:
{
 options = {
    mod-steam.enable = lib.mkEnableOption "setup steam";
 };
 config = lib.mkIf config.mod-steam.enable {
    
    environment.systemPackages = with pkgs; [
        # only really use mangohud with steam so might as well put this here.
        mangohud
        protonup-qt
    ];
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

    # enable these if using boxtron or the scummvm version of boxtron
    #libnotify
    #dosbox
    #scummvm
    ];
    programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
    ];
 };

}
