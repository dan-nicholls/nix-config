{...}: {
  flake.nixosModules.x1-carbonSamba = {config, ...}: {
    sops.defaultSopsFile = ../../../secrets/secrets.yml;

    sops.secrets.samba-credentials.mode = "0400";

    fileSystems."/mnt/shared" = {
      device = "//192.168.8.205/general";
      fsType = "cifs";
      options = [
        "credentials=${config.sops.secrets.samba-credentials.path}"
        "uid=1000"
        "gid=100"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "noauto"
        "nofail"
        "_netdev"
        "file_mode=0644"
        "dir_mode=0755"
        "vers=3.0"
      ];
    };
  };
}
