{
  flake.modules.nixos.graphical = { pkgs, config, ...}: 
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

  };
}
