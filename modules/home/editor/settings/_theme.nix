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

  extraConfig = ''
  local function hl()
    local set = vim.api.nvim_set_hl

    -- UI ------------------------------------------------------------

    set(0, "Normal", {
      fg = "${self.theme.base05}",
      bg = "${self.theme.base00}",
    })

    set(0, "NormalNC", {
      bg = "${self.theme.base00}",
    })

    set(0, "LineNr", {
      fg = "${self.theme.base03}",
    })

    set(0, "CursorLineNr", {
      fg = "${self.theme.base05}",
      bold = true,
    })

    set(0, "CursorLine", {
      bg = "${self.theme.base01}",
    })

    set(0, "Visual", {
      bg = "${self.theme.base02}",
    })

    set(0, "MatchParen", {
      bg = "${self.theme.base02}",
      bold = true,
    })

    set(0, "WinSeparator", {
      fg = "${self.theme.base01}",
    })

    -- Floating windows ---------------------------------------------

    set(0, "NormalFloat", {
      bg = "${self.theme.base01}",
    })

    set(0, "FloatBorder", {
      fg = "${self.theme.base03}",
      bg = "${self.theme.base01}",
    })

    -- Popup menu ---------------------------------------------------

    set(0, "Pmenu", {
      fg = "${self.theme.base05}",
      bg = "${self.theme.base01}",
    })

    set(0, "PmenuSel", {
      fg = "${self.theme.base00}",
      bg = "${self.theme.base0D}",
      bold = true,
    })

    -- Search -------------------------------------------------------

    set(0, "Search", {
      fg = "${self.theme.base00}",
      bg = "${self.theme.base0A}",
    })

    set(0, "IncSearch", {
      fg = "${self.theme.base00}",
      bg = "${self.theme.base09}",
    })

    -- Diagnostics --------------------------------------------------

    set(0, "DiagnosticError", {
      fg = "${self.theme.base08}",
    })

    set(0, "DiagnosticWarn", {
      fg = "${self.theme.base09}",
    })

    set(0, "DiagnosticInfo", {
      fg = "${self.theme.base0D}",
    })

    set(0, "DiagnosticHint", {
      fg = "${self.theme.base0C}",
    })

    -- GitSigns -----------------------------------------------------

    set(0, "GitSignsAdd", {
      fg = "${self.theme.base0B}",
    })

    set(0, "GitSignsChange", {
      fg = "${self.theme.base0D}",
    })

    set(0, "GitSignsDelete", {
      fg = "${self.theme.base08}",
    })

    -- Syntax / Treesitter ------------------------------------------

    set(0, "Comment", {
      fg = "${self.theme.base03}",
      italic = true,
    })

    set(0, "@keyword", {
      fg = "${self.theme.base0E}",
    })

    set(0, "@function", {
      fg = "${self.theme.base0D}",
    })

    set(0, "@string", {
      fg = "${self.theme.base0B}",
    })

    set(0, "@type", {
      fg = "${self.theme.base0A}",
    })

    -- Telescope ----------------------------------------------------

    set(0, "TelescopeBorder", {
      fg = "${self.theme.base03}",
      bg = "${self.theme.base00}",
    })

    set(0, "TelescopeSelection", {
      bg = "${self.theme.base01}",
    })

    -- Lualine ------------------------------------------------------

    require("lualine").setup({
      options = {
        theme = {
          normal = {
            a = {
              fg = "${self.theme.base00}",
              bg = "${self.theme.base0D}",
              gui = "bold",
            },
            b = {
              fg = "${self.theme.base04}",
              bg = "${self.theme.base01}",
            },
            c = {
              fg = "${self.theme.base03}",
              bg = "${self.theme.base00}",
            },
          },

          insert = {
            a = {
              fg = "${self.theme.base00}",
              bg = "${self.theme.base0B}",
              gui = "bold",
            },
          },

          visual = {
            a = {
              fg = "${self.theme.base00}",
              bg = "${self.theme.base0E}",
              gui = "bold",
            },
          },

          replace = {
            a = {
              fg = "${self.theme.base00}",
              bg = "${self.theme.base08}",
              gui = "bold",
            },
          },

          command = {
            a = {
              fg = "${self.theme.base00}",
              bg = "${self.theme.base09}",
              gui = "bold",
            },
          },

          inactive = {
            a = {
              fg = "${self.theme.base03}",
              bg = "${self.theme.base01}",
            },
            b = {
              fg = "${self.theme.base03}",
              bg = "${self.theme.base01}",
            },
            c = {
              fg = "${self.theme.base03}",
              bg = "${self.theme.base00}",
            },
          },
        },

        component_separators = {
          left = "│",
          right = "│",
        },

        section_separators = {
          left = "",
          right = "",
        },

        globalstatus = true,
      },

      sections = {
        lualine_a = { "mode" },

        lualine_b = {
          "branch",
          {
            "diff",
            colored = true,
          },
        },

        lualine_c = {
          {
            "filename",
            path = 1,
          },
        },

        lualine_x = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
          },
          "encoding",
          "filetype",
        },

        lualine_y = { "progress" },

        lualine_z = { "location" },
      },

      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = hl,
  })

  vim.schedule(hl)
'';

}
