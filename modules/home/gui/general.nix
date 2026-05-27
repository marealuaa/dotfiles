{ inputs, ... }: {
  flake.modules.nixos.gui = { pkgs, config, ...}: 
  {
    hardware.bluetooth.enable = true;
    security.rtkit.enable = config.services.pipewire.enable; 
    xdg.portal.xdgOpenUsePortal = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = [
      inputs.concord.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  };
}
