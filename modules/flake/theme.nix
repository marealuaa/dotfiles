let
  theme = {
   base00 = "#181616"; # bg
   base01 = "#0d0c0c"; # black
   base02 = "#2d4f67"; # blue
   base03 = "#a6a69c"; # gray
   base04 = "#7fb4ca"; # cyan
   base05 = "#c5c9c5"; # fg
   base06 = "#938aa9"; # purple
   base07 = "#c5c9c5"; # light
   base08 = "#c4746e"; # red
   base09 = "#e46876"; # rose
   base0A = "#c4b28a"; # yellow
   base0B = "#8a9a7b"; # green
   base0C = "#8ea4a2"; # teal
   base0D = "#8ba4b0"; # blue
   base0E = "#a292a3"; # magenta
   base0F = "#7aa89f"; # mint
  };

  cursor = {
    theme = "Bibata Original Classic";
    size = 20;
    package = pkgs: pkgs.bibata-cursors;
  };

  font = {
    mono = "JetBrains Mono Nerd Font";
    size = 12;
    packages = pkgs: with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
in 
{
  flake = { inherit theme cursor font; };
}
