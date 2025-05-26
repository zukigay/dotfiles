{config, lib, pkgs, ...}:
{
  options = {
    mod-vr.enable = 
    	lib.mkEnableOption "enables vr support via wivrn and adds the wlx overlay";
  };
  config = lib.mkIf config.mod-vr.enable {
    networking.firewall = {
            allowedTCPPorts = [
          9757
        ];
        allowedUDPPorts = [
        5353
        9757
        ];
    };
    services.wivrn.enable = true;
    environment.systemPackages = with pkgs; [
      wlx-overlay-s
    ];
  };
}
