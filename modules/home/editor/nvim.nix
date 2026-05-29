{ self, inputs, ... }: 
{
  flake.modules.nixos.editor = {
    imports = [ inputs.nvf.nixosModules.default ];
    
    programs.nvf = {
      enable = true;

      settings.vim = import ./settings/_languages.nix // {
        viAlias = true;
        vimAlias = true;

        opts = {
          autoindent = true;
          shiftwidth = 2;
          tabstop = 2;
          cursorlineopt = "both";
          termguicolors = true;
          wrap = true;
        };

        theme = import ./settings/_theme.nix { inherit self; };

        # plugins
        telescope.enable = true;

        filetree.nvimTree.enable = true;
        filetree.nvimTree.openOnSetup = true;

        statusline.lualine =  {
          enable = true;
          icons.enable = true;
          globalStatus = true;
        };

      };
    };
  };  
}
