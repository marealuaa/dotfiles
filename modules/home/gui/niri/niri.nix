{ self, inputs, ... }: 
{
  perSystem = { pkgs, ... }: {
    packages.niri = inputs.wrappers.wrappers.niri.wrap {
      inherit pkgs;
      settings = import ./_settings.nix { inherit self; };
      runtimePkgs = with pkgs; [
        awww
        wl-clipboard
        cliphist
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

    environment.systemPackages = [(self.cursor.package pkgs)];
    fonts.packages = self.font.packages pkgs;
  };
}
