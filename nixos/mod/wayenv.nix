{config, lib,pkgs, ...}:
{
 options = {
    mod-wayenv.enable = lib.mkEnableOption "setup wayland-env's";
 };
 config = lib.mkIf config.mod-wayenv.enable {
    environment.sessionVariables = {
        MOZ_ENABLE_WAYLAND="1";
        NVD_BACKEND="direct";
        ELECTRON_OZONE_PLATFORM_HINT="auto";
        # XDG_CURRENT_DESKTOP="dwl";
        XDG_SESSION_TYPE="wayland";
    };
 };
}
