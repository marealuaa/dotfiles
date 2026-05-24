{
  flake.modules.nixos.host_laptop = { config, lib, pkgs, modulesPath, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
    
    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b1c5c48c-28e7-4458-8f7e-08275667302c";
        fsType = "ext4";
      };
    
    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/6450-FFD7";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };
    
    swapDevices =
      [ { device = "/dev/disk/by-uuid/9eec6628-ba3c-418e-ab5c-5edba229f10b"; }
      ];
    
    networking.useDHCP = lib.mkDefault true;
    
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
