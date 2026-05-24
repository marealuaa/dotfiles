{
  flake.modules.nixos.networking = { ... }: 
  {
    networking = {
      networkmanager.enable = true;
      firewall.enable = true;
    };

    services.resolved = {
      enable = true;
      fallbackDns = [ "1.1.1.1" ];
    };

    services.printing.enable = true;
  };
}
