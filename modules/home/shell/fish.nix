{ self, inputs, ... }: {
  perSystem = { pkgs, lib, self', ... }: 
  let
    config = ''
      set fish_greeting
      fish_vi_key_bindings

      ${lib.getExe pkgs.zoxide} init fish | source

      ${lib.getExe pkgs.starship} init fish | source
    '';

    alias = {
      ls = "eza --icons --git";
      rmdir = "rmdir --ignore-fail-on-non-empty";
    };

    env = {
      NH_FLAKE = "/home/mari/dotfiles";
      GIT_AUTHOR_NAME = "mari";
      GIT_AUTHOR_EMAIL = "mari@sea.lua";
      GIT_COMMITTER_NAME = "mari";
      GIT_COMMITTER_EMAIL = "mari@sea.lua";
    };

  in {
    packages.fish = inputs.wrappers.wrappers.fish.wrap {
      inherit pkgs;
      runtimePkgs = [
        pkgs.git
        pkgs.nh

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
        self'.packages.starship
      ];

      configFile.content = config;
      shellAliases = alias;
      env = env;
    };
  };

  flake.modules.nixos.shell = { pkgs, ... }: 
  {
    programs.fish = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.fish;   
    };
  };
}
