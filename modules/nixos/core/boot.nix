{ inputs, ... }: 
{
  flake.modules.nixos.boot = { lib, pkgs, ... }:
  {
    nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];    

    boot = {
      kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest;
      kernelParams = [
	"nowatchdog"
	"preempt=full"
      ];

      loader = {
        systemd-boot = {
	  enable = true;
	  configurationLimit = 7;
	  consoleMode = "max";
	  editor = false;
	};

	efi.canTouchEfiVariables = true;
	timeout = 3;
      };
    };
  };
}
