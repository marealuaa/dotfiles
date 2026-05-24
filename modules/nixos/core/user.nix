{ self, ... }: 
{
  flake.modules.nixos.user = { config, pkgs, lib, ... }: let
    user = config.preferences.user.name;
    fish = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;
  in
  {
    imports = with self.modules.nixos; [
 #     hjem
    ];      

    users.users.${user} = {
      isNormalUser = true;
      shell = fish;
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };
}
