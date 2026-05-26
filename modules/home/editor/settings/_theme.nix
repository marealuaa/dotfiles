{ self, ... }:
{
  enable = true;
  name = "base16";
  base16-colors = {
    base00 = self.theme.base00;
    base01 = self.theme.base01;
    base02 = self.theme.base02;
    base03 = self.theme.base03;
    base04 = self.theme.base04;
    base05 = self.theme.base05;
    base06 = self.theme.base06;
    base07 = self.theme.base07;
    base08 = self.theme.base08;
    base09 = self.theme.base09;
    base0A = self.theme.base0A;
    base0B = self.theme.base0B;
    base0C = self.theme.base0C;
    base0D = self.theme.base0D;
    base0E = self.theme.base0E;
    base0F = self.theme.base0F;
  };

#  extraConfig = ''
#   local function hl()
#      vim.api.nvim_set_hl(0, "LineNr", {
 #       fg = "${self.theme.base04}",
 #     })
 #
 #     vim.api.nvim_set_hl(0, "CursorLineNr", {
 #       fg = "${self.theme.base05}",
 #       bold = true,
 #     })
 #
 #     vim.api.nvim_set_hl(0, "CursorLine", {
 #       bg = "${self.theme.base03}",
 #     })
 #
 #     vim.api.nvim_set_hl(0, "Visual", {
 #       bg = "${self.theme.base03}",
 #     })
#
#      vim.api.nvim_set_hl(0, "MatchParen", {
#        bg = "${self.theme.base03}",
 #       fg = "NONE",
 #       bold = true,
 #     })
 #   end
 #
 #   vim.schedule(hl)
#
#    vim.api.nvim_create_autocmd("ColorScheme", {
#      callback = hl,
#    })
#  '';
}
