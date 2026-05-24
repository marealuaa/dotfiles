{ self, inputs, ... }: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.modules.nixos.host_laptop ];
  };

  flake.modules.nixos.host_laptop = {
    imports = with self.modules.nixos; 
    [
      preferences

      base
      boot
      graphical
      nix-settings
      networking
      user

      laptop
      steam

      wm
      shell
      terminal
      editor
    ];
  };

}
