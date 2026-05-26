{ self, inputs, ... }: 
{
  flake.modules.nixos.editor = {
    imports = [ inputs.nvf.nixosModules.default ];
    
    programs.nvf = {
      enable = true;
      settings = import ./_settings.nix;
    };
  };  
}
