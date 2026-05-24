{ inputs, ... }: 
{
  flake.modules.nixos.editor = {
    imports = [ inputs.nvf.nixosModules.default ];
    
    programs.nvf = {
      enable = true;
    };
  };  
}
