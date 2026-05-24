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
        #for fun
        pkgs.ani-cli

	#wraps
	self'.packages.git
	self'.packages.nh
      ];
    };
  };

  flake.modules.nixos.shell = { pkgs, lib, ... }: 
  let
    config = ''
      function fish_prompt
        echo -n "> "
      end
	
      set fish_greeting
      fish_vi_key_bindings

      ${lib.getExe pkgs.zoxide} init fish | source
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
