{config, lib,pkgs, ...}:
{
 options = {
    mod-waynvidiaenv.enable = lib.mkEnableOption "setup wayland-env's (nvidia)";
 };
 config = lib.mkIf config.mod-waynvidiaenv.enable {
    environment.sessionVariables = {
        #NVD_BACKEND="direct";
        # ELECTRON_OZONE_PLATFORM_HINT="x11";
        __GLX_VENDOR_LIBRARY_NAME="nvidia";
        GBM_BACKEND="nvidia-drm";
    };
    environment.sessionVariables.ELECTRON_OZONE_PLATFORM_HINT = lib.mkForce "x11";
 };
}
