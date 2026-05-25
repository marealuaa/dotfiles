{ self, inputs, ... }: {
  perSystem = { config, pkgs, ... }: let
    user = config.preferences.user.name;
  in {
    packages.nh = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.nh;
      env = {
        NH_FLAKE = "$HOME/dotfiles";
      };
    };
  };
}
