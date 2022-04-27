{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # legacy boot
  boot.loader.grub.device = "/dev/sda";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [ it87 ];
  boot.kernelModules = ["coretemp" "it87"];

  networking.hostName = "DeepThought";

  # Enable flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # allowUnfree
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "99-en-dhcp" = {
        matchConfig.name = "en*";
        networkConfig.DHCP = "yes";
      };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.hurricane = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$6$yqI.HyY9byvlQpjn$9gM1JHXUD9xKPS6m.OYYRxWlCs7ujPgRXq3B3bEdgVhOCOZevogFnx19sqskEd2XShtVIxniXLIdbMPlh8J710";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAB/QDa0fOiCcKHs+Ke0u44KAT1kLAjqO4r8MDxtsdWkG+GHhwxsGFKGB2kEhSzmoiMHTVgfLscifCx9z12yRdmmTIkrwRkuOZOx8wlqnVBckq7ZvZBFcA9KK+lG0CcLbwNKCqYBJIgUGLTmpJuyX4OKJlS7tIPCibHaswaiN6Hu6NWl4Rp/3FjjmQkG2alivjtWLh3Lr3c5Gzgw1T8v2yMB7piIxy0a5u4Pp28kkILQ1VABqTUJ50Uzx5Jfi4+oVCBEIliK/60wVqRT6rDSr3/x9QskiDRpJvgDldiwUGJBuVahuc6qW2QzKMAkk/gtJYpURhDNwAie6Fjd7HR2AhZPrBmILFNYclWk1E3MvhWgZ0iaW5W++XqH33pH/xpT9rgvH7yPuSz5tbLWZN0KMHeaGvzzGZzhdrvHBcYK/55p/n+W8jBjRXnZ6bPqyCy1TPOkv4LdYOAQuL5nnGOIWD1UE+mZfelOXl1pLgQ0tG99Un6BjqIdew2dOvp7eKBDDDeWg6aU9Ct8GQygHaRkkAPe6AabBmIltjVooTBXcNhiAuvTA3ZT67BiHufsnsJ9T7OjSnH4cVP4g4SVZQZnuDsOkC7Aao/z0v/V+BT7xe2IEHwZdc8fcuC36yz5u4PgyNdRtinUHiKG5VBK8BZAiCG0JA0CVX6ZDygRDf9Kofx"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDMa/rzAQl4OIi9NT8QAsWfAg4tdnZCHbDHBtw9RJbUVVXYdzBfivttwq+3YNL0j2EPNqg9cBn0Oa37btTMNqQJJLhnIi03dBNILWrIEtpTLjTSayjSz+1oU7Ksv8vin5dSqeipRd/D0LXTH8liEr2YnDqYhrHQrtWE/o3fKzE4kqEUfafF/pksobe1NkyztajC+kVG5o8QmFKJRJY7saCpgNzCn4PmWs3/Qqjf/off0EL3yst1S9YAQKyk/SlznDPkypGiNiFc2dKvI1oUNgRsmY43zkO3ap7ZxFtAY//sNXuw+htTexmxNZG9Uca6SnKBKvo9nQJ1JqVfqBgkQPSqGB0GAnS1tj3GpXoNpk8paSm4TvlgzRRY884ipBxj9pbB+nwYElgoxT1/B1uJ4hY0jywE11+Mt915D9d8LBmT/2THR73Czw2QPEtYdXwjhhB2OVyrPMhExXtEsdJjZ3iFieatx7QnW+/6x9aUA4wRbEhnUYgxRE8Ybudtuz+bnLzzTaxIdaoip4qK2AzIifXm5ByjYlGnEwmGKj/k7A0VW/iToew9lESLNypRsbwgxeykix0BwkL8UCoWUhtmRxyxGxfV6yAVdRyWnXIgTaOPzXOU8l6vzPigI/GFTnE74llCXJT0GVsb/Tl5b2WRl9pgSkPHHBW3XFJx7MRyQTNDrQ=="
    ];
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    neovim
    wget
    mergerfs
    mergerfs-tools
    snapraid
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Samba
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = DeepThought
      server role = standalone server
      guest account = nobody
      map to guest = Bad User
      min protocol = SMB2
      ea support = yes
    '';
    shares = {
      public = {
        path = "/shares/public";
        comment = "Public samba share.";
        "guest ok" = "yes";
        "read only" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "nogroup";
      };
    };
  };

  # mDNS
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
        </service-group>
      '';
    };
  };

  # Terramaster's fan is connected to a case fan header.
  # It doesn't spin up under load so I set up fancontrol to take care of this.
  # source: https://github.com/arnarg/config/blob/master/machines/terramaster/configuration.nix#L52-L68
  hardware.fancontrol.enable = true;
  # Because of the order in boot.kernelModules coretemp is always loaded before it87.
  # This makes hwmon0 coretemp and hwmon1 it8613e (acpitz is hwmon2).
  # This seems to be consistent between reboots.
  hardware.fancontrol.config = ''
    INTERVAL=10
    DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/it87.2592
    DEVNAME=hwmon0=coretemp hwmon1=it8613
    FCTEMPS=hwmon1/pwm3=hwmon0/temp1_input
    FCFANS= hwmon1/pwm3=hwmon1/fan3_input
    MINTEMP=hwmon1/pwm3=20
    MAXTEMP=hwmon1/pwm3=60
    MINSTART=hwmon1/pwm3=52
    MINSTOP=hwmon1/pwm3=12
  '';

  security.sudo.extraRules = [
    {
      users = [ "hurricane" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  system.activationScripts.installerCustom = ''
    mkdir -p /shares/public
  '';

  system.stateVersion = "21.11";
}

# vim: set et sw=2 :
