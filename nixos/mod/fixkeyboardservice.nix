{config, lib, ...}:
# {config, lib, ...}:
{
  options = {
    mod-keyboardfix.enable = 
    	lib.mkEnableOption "changes hid apple to fn mode so that my keyboards fn keys work normally";
  };
  config = lib.mkIf config.mod-keyboardfix.enable {
        systemd.services.fixmykeyboard = {
            script = ''
            echo 0 | tee /sys/module/hid_apple/parameters/fnmode
            '';
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                type = "oneshot";
            };
        };
    };
}
