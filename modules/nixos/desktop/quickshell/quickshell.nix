{ self, inputs, ... }: 
{
  perSystem = { pkgs, ... }: {
    packages.quickshell = inputs.wrappers.wrappers.quickshell.wrap {
      inherit pkgs;
      configDir = ./_settings;
    };
  };  

  flake.modules.nixos.wm = { pkgs, ... }: 
  let
    quickshell = self.packages.${pkgs.stdenv.hostPlatform.system}.quickshell;
  in
  {
    environment.systemPackages = [ quickshell ];
  };
}
