{ self, inputs, ... }: {
  perSystem = { pkgs, self', ... }: 
  {
    packages.fish = inputs.wrappers.wrappers.fish.wrap {
      inherit pkgs;
      runtimePkgs = [
        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.fzf
        pkgs.btop
        pkgs.eza
        pkgs.ripgrep
        pkgs.zoxide
        pkgs.tree-sitter
        pkgs.yt-dlp
        pkgs.nh
        #for fun
        pkgs.ani-cli

	#wraps
        pkgs.starship
	self'.packages.git
      ];
    };
  };

  flake.modules.nixos.shell = { pkgs, lib, ... }: 
  let
    config = ''
      set fish_greeting
      fish_vi_key_bindings

      set -x NH_FLAKE /home/mari/dotfiles

      ${lib.getExe pkgs.zoxide} init fish | source

      ${lib.getExe pkgs.starship} init fish | source
    '';

    alias = {
      ls = "eza --icons --git";
      rmdir = "rmdir --ignore-fail-on-non-empty";
    };

    fish' = self.packages.${pkgs.stdenv.hostPlatform.system}.fish.wrap {
      configFile.content = config;
      shellAliases = alias;
    };
  in   
  {
    programs.fish = {
      enable = true;
      package = fish';   
    };
  };
}
