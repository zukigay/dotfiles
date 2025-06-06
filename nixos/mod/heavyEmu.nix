{config, lib,pkgs, ...}:
{
 options = {
    mod-heavyEmu.enable = lib.mkEnableOption "add some of the more heavy emulators";
 };
 config = lib.mkIf config.mod-heavyEmu.enable {
    environment.systemPackages = with pkgs; [
        ares # i only use ares for n64 emulation so it counts as a heavy emulator in my head.
        pcsx2
        cemu
        azahar
    ];
 };
}
