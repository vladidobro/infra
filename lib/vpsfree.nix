{ inputs, self, ... }:
let config = { config, pkgs, lib, ... }:
  let
    nameservers = [ "1.1.1.1" "2606:4700:4700::1111" ];
  in 
  with lib;
  {
    networking.nameservers = mkDefault nameservers;
    services.resolved = mkDefault { fallbackDns = nameservers; };
    networking.dhcpcd.extraConfig = "noipv4ll";

    systemd.services.systemd-sysctl.enable = false;
    systemd.services.systemd-oomd.enable = false;
    systemd.sockets."systemd-journald-audit".enable = false;
    systemd.mounts = [ {where = "/sys/kernel/debug"; enable = false;} ];
    systemd.services.rpc-gssd.enable = false;

    systemd.additionalUpstreamSystemUnits = [
      "systemd-udev-trigger.service"
    ];
    systemd.services.systemd-udev-trigger.serviceConfig.ExecStart = [
      ""
      "-udevadm trigger --subsystem-match=net --action=add"
    ];

    boot.isContainer = true;
    boot.enableContainers = mkDefault true;
    boot.loader.initScript.enable = true;
    boot.specialFileSystems."/run/keys".fsType = mkForce "tmpfs";
    boot.systemdExecutable = mkDefault "/run/current-system/systemd/lib/systemd/systemd systemd.unified_cgroup_hierarchy=0";

    documentation.enable = mkOverride 500 true;
    documentation.nixos.enable = mkOverride 500 true;
    networking.useHostResolvConf = mkOverride 500 false;
    services.openssh.startWhenNeeded = mkOverride 500 false;

    systemd.services.networking-setup = {
      description = "Load network configuration provided by the vpsAdminOS host";
      before = [ "network.target" ];
      wantedBy = [ "network.target" ];
      after = [ "network-pre.target" ];
      path = [ pkgs.iproute2 ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash /ifcfg.add";
        ExecStop = "${pkgs.bash}/bin/bash /ifcfg.del";
      };
      unitConfig.ConditionPathExists = "/ifcfg.add";
      restartIfChanged = false;
    };
  };
in {
  flake.nixosModules.vpsfree = config;
}
