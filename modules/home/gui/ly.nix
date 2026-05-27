{ self, ... }: 
{
  flake.modules.nixos.gui = {...}: 
  let
    c = color: "0x00${builtins.substring 1 6 color}";
  in 
  {
    services.displayManager.ly = {
      enable = true;
      settings = {
        # colors
        bg = c self.theme.base00;
        fg = c self.theme.base07;
        border_fg = c self.theme.base07;
        error_fg = c self.theme.base08;
      };
    };

  };
}
