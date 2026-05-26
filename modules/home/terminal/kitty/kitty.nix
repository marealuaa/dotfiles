{ self, inputs, ... }:

{
  perSystem = { pkgs, ... }: {
    packages.kitty = inputs.wrappers.wrappers.kitty.wrap {
      inherit pkgs;
      settings = import ./_settings.nix { inherit self; };
    };
  };

  flake.modules.nixos.terminal = { config, pkgs, lib, ... }:
  let
    kitty = self.packages.${pkgs.stdenv.hostPlatform.system}.kitty;
  in
  {
    environment.systemPackages = [ kitty ];
    preferences.keybinds."Mod+Return".spawn = lib.getExe kitty;
  };
}
