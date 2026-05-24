{
  flake.modules.nixos.base = { lib, ... }: 
  {
    system.stateVersion = lib.mkDefault "26.05";

    time.timeZone = lib.mkDefault "Europe/Rome";
    i18n.defaultLocale = lib.mkDefault "en_GB.UTF-8";

    documentation = {
      enable = lib.mkDefault false;
      doc.enable = lib.mkDefault false;
      info.enable = lib.mkDefault false;
      nixos.enable = lib.mkDefault false;
    };

  };
}
