{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    config = pkgs.writeText "starship.toml" ''
      "$schema" = "https://starship.rs/config-schema.json"

        format = """
        $username$hostname$directory$git_branch
        $all
        $character
        """

        add_newline = true

        [character]
        success_symbol = "❯ "
        error_symbol = "❯ "

        [git_branch]
        symbol = " "

        [directory]
        read_only = " 󰌾"

        [package]
        symbol = "󰏗 "

        [python]
        symbol = " "

        [rust]
        symbol = "󱘗 "

        [c]
        symbol = " "

        [cpp]
        symbol = " "

        [nodejs]
        symbol = " "

        [lua]
        symbol = " "

        [nix_shell]
        symbol = " "

        [direnv]
        symbol = " "

        [typst]
        symbol = " "

        [latex]
        symbol = " "

        [os.symbols]
        NixOS = " "
    '';
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env.STARSHIP_CONFIG = config;
    };
  };
}
