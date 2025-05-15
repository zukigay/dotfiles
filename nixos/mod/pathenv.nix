{config, lib,pkgs, ...}:
{
 options = {
    mod-pathenv.enable = lib.mkEnableOption "set $PATH";
 };
 config = lib.mkIf config.mod-pathenv.enable {
    environment.sessionVariables = lib.mkForce rec {
         PATH="$PATH:/home/zuki/.cargo/bin:$HOME/.scripts/:$HOME/.scripts/bookmarks/:$HOME/.local/bin/:/home/zuki/.local/share/cargo/bin:$HOME/Applications:$GOPATH/bin";
    };
 };
}
