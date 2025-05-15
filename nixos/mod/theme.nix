{config, lib,pkgs, ...}:
{
 options = {
    mod-theme.enable = lib.mkEnableOption "setup theme stuff";
 };
 config = lib.mkIf config.mod-theme.enable {
    environment.sessionVariables = {
        # enable qt6ct
        QT_QPA_PLATFORMTHEME="qt5ct:qt6ct";
    };
    environment.systemPackages = with pkgs; [
        # add qt6ct pkgs
        qt6ct
        libsForQt5.qt5ct
        # add cursor icon theme
        adwaita-icon-theme
    ];
 };
}
