{config, lib, ...}:
# {config, lib, ...}:
{
  options = {
    mod-intelNoTurbo.enable = 
    	lib.mkEnableOption "set max intel clock to non turbo mode";
  };
  config = lib.mkIf config.mod-intelNoTurbo.enable {
        systemd.services.fixmykeyboard = {
            script = ''
            echo 1 | tee /sys/devices/system/cpu/intel_pstate/no_turbo
            '';
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
                type = "oneshot";
            };
        };
    };
}
