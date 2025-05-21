{config, lib, ...}:
# {config, lib, ...}:
{
    systemd.services.fixmykeyboard = {
        script = ''
        echo 0 | tee /sys/module/hid_apple/parameters/fnmode
        '';
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
            type = "oneshot";
        };
    };
}
