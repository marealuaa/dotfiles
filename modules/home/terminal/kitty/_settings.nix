{ self }: {
  window_padding_width = 10;
  hide_window_decorations = "yes";
  confirm_os_window_close = 0;

  font_family = "JetBrains Mono Nerd Font";

  cursor_shape = "beam";
  cursor_shape_unfocused = "beam";
  cursor_blink_interval = 0;
  enable_audio_bell = "no";
  cursor_trail = 3;

  background = self.theme.base00;
  foreground = self.theme.base05;

  selection_background = self.theme.base02;
  selection_foreground = self.theme.base05;

  # normal
  color0  = self.theme.base01; # black
  color1  = self.theme.base08; # red
  color2  = self.theme.base0B; # green
  color3  = self.theme.base0A; # yellow
  color4  = self.theme.base0D; # blue
  color5  = self.theme.base0E; # magenta
  color6  = self.theme.base0C; # cyan
  color7  = self.theme.base05; # white

  # bright
  color8  = self.theme.base03; # bright black / gray
  color9  = self.theme.base09; # bright red
  color10 = self.theme.base0B; # bright green
  color11 = self.theme.base0A; # bright yellow
  color12 = self.theme.base04; # bright blue/cyan
  color13 = self.theme.base06; # bright magenta
  color14 = self.theme.base0F; # bright cyan/mint
  color15 = self.theme.base07; # bright white

  # extended
  color16 = self.theme.base09;
  color17 = self.theme.base0F;
  color18 = self.theme.base01;
  color19 = self.theme.base02;
  color20 = self.theme.base03;
  color21 = self.theme.base04;
}
