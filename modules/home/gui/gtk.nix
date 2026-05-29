{ self, ... }: {
  flake.modules.nixos.gui = { pkgs, lib, ... }: 
  let
    theme-name = "Kanagawa-Dragon-BL-MB";

    theme-package = pkgs.stdenvNoCC.mkDerivation {
  pname = "kanagawa-gtk-theme";
  version = "0-unstable-2023-07-03";

  src = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "main";
    hash = "sha256-UdMoMx2DoovcxSp/zBZ3PRv/Qpj+prd0uPm1gmdak2E=";
  };

  nativeBuildInputs = [
    pkgs.sassc
    pkgs.gtk3
  ];

installPhase = ''
  runHook preInstall

  mkdir -p $out/share/themes
  cp -a themes/* $out/share/themes

  runHook postInstall
'';
};

    icon-theme-name = "Kanagawa";
    icon-theme-package = pkgs.kanagawa-icon-theme;

    gtksettings = ''
      [Settings]
      gtk-icon-theme-name = ${icon-theme-name}
      gtk-theme-name = ${theme-name}
      gtk-cursor-theme-name = ${self.cursor.name}
      gtk-cursor-theme-size = ${toString self.cursor.size}
    '';
  in 
  {
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = gtksettings;
      "xdg/gtk-4.0/settings.ini".text = gtksettings;
    };

    environment.variables = {
      GTK_THEME = theme-name;
      XCURSOR_THEME = self.cursor.name;
      XCURSOR_SIZE = toString self.cursor.size;
    };

    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [{
        lockAll = false;
        settings."org/gnome/desktop/interface" = {
          gtk-theme = theme-name;
          icon-theme = icon-theme-name;
          color-scheme = "prefer-dark";
        };
      }];
    };
    environment.systemPackages = [
      theme-package
      icon-theme-package
      pkgs.gtk3
      pkgs.gtk4
      pkgs.gtk-engine-murrine
    ];
  };
}
