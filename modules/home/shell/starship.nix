{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    config = pkgs.writeText "starship.toml" ''
      format = """
      $username\
      $hostname\
      $directory\
      $git_branch\
      $character
      """

      add_newline = false

      [character]
      success_symbol = "[❯](bold green)"
      error_symbol = "[❯](bold red)"
    '';
  in {
    packages.starship = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.starship;
      env.STARSHIP_CONFIG = config;
    };
  };
}
