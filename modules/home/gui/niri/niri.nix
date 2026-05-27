{ self, inputs, ... }: 
{
  perSystem = { pkgs, ... }: {
    packages.niri = inputs.wrappers.wrappers.niri.wrap {
      inherit pkgs;
      settings = import ./_settings.nix;
      runtimePkgs = [
        pkgs.awww
        self.font.packages
        self.cursor.package
      ];
    };
  };

  flake.modules.nixos.gui = { pkgs, config, ... }: 
  let
    niri' = self.packages.${pkgs.stdenv.hostPlatform.system}.niri.wrap {
      settings.binds = config.preferences.keybinds;
    };
  in 
  {
    programs.niri = {
      enable = true;
      package = niri';
    };
  };
}
