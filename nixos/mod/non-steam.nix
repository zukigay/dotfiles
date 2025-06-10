{config, lib,pkgs, ...}:
{
 options = {
    mod-nonSteam.enable = lib.mkEnableOption "non steam games/tools";
 };
 config = lib.mkIf config.mod-nonSteam.enable {
    environment.systemPackages = with pkgs; [
        mangohud
        dosbox
        scummvm

        # altertive epic games clients
        heroic
        # rare
    ];
 };

}
