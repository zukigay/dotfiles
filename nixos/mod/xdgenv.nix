{config, lib,pkgs, ...}:
{
 options = {
    mod-xdgenv.enable = lib.mkEnableOption "set xdg ninja env's";
 };
 config = lib.mkIf config.mod-wayenv.enable {
    environment.sessionVariables = rec {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
        XDG_BIN_HOME    = "$HOME/.local/bin";
        PATH = [ 
          "${XDG_BIN_HOME}"
        ];
        RENPY_PATH_TO_SAVES="${XDG_DATA_HOME}/renpy";
        CARGO_HOME="${XDG_DATA_HOME}/cargo";
        RUSTUP_HOME="${XDG_DATA_HOME}/rustup";
        GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
        KDEHOME="${XDG_CONFIG_HOME}/kde";
        CUDA_CACHE_PATH="${XDG_CACHE_HOME}/nv";
        XINITRC="${XDG_CONFIG_HOME}/x11/xinitrc";
        ANDROID_HOME="${XDG_DATA_HOME}/android";
        WINEPREFIX="${XDG_DATA_HOME}/wine";
        CRAWL_DIR="${XDG_DATA_HOME}/crawl";
        DVDCSS_CACHE="${XDG_DATA_HOME}/dvdcss";
        GOPATH="${XDG_DATA_HOME}/go";
        ZDOTDIR="${XDG_CONFIG_HOME}/zsh";
        LESSHISTFILE="${XDG_CACHE_HOME}/less/history";

        # this doesn't quite count but shhh its fine
        GTK_USE_PORTAL=1;
        GRIM_DEFAULT_DIR="$HOME/screenshots/";
        DXVK_ASYNC=1;
        EDITOR="nvim";

    };
 };
}
