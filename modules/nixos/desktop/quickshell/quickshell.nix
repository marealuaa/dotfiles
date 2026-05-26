{ self, inputs, ... }: 
{
  perSystem = { pkgs, ... }: {
    packages.quickshell = inputs.wrappers.wrappers.quickshell.wrap {
      inherit pkgs;
      configFile = ./_settings/shell.qml;
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
