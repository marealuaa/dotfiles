{ self, inputs, ... }: 
{
  flake.modules.nixos.editor = {
    imports = [ inputs.nvf.nixosModules.default ];
    
    programs.nvf = {
      enable = true;

      settings.vim = {
        viAlias = true;
        vimAlias = true;

        theme = import ./settings/_theme.nix { inherit self; };

        # plugins
        telescope.enable = true;

        filetree.nvimTree.enable = true;
        filetree.nvimTree.openOnSetup = true;

      };
    };
  };  
}
