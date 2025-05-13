{config, lib,pkgs, ...}:
{
  fileSystems."/mnt/uberdrive" =
    { device = "/dev/disk/by-label/uberdrive";
      fsType = "ext4";
      options = [ "nofail"];
    };
  fileSystems."/mnt/ssddrive" =
    { device = "/dev/disk/by-label/exlapdrive";
      fsType = "ext4";
      options = [ "nofail"];
    };
  fileSystems."/mnt/harddrive" =
    { device = "/dev/disk/by-uuid/08d01f59-dee1-4c01-b1c3-0200d5ec8264";
      fsType = "ext4";
      options = [ "nofail"];
    };
}
