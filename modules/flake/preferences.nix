{
  flake.modules.nixos.preferences = { lib, ... }: {
    options.preferences = {
      # username, self explanatory
      user.name = lib.mkOption {
	type = lib.types.str;
	default = "mari";
      };

      # wm stuff
      keybinds = lib.mkOption {
	type = lib.types.attrsOf lib.types.anything;
	default = { };
      };
    };
  };
}
