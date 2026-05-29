{
  lsp.enable = true;
  lsp.formatOnSave = true;

  languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix.enable = true;
    clang.enable = true;
    python.enable = true;

    rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
    };

    fish.enable = true;

    html.enable = true;
    css.enable = true;
    typescript.enable = true;

    typst.enable = true;
  };

  autocomplete.blink-cmp = {
    enable = true;
    friendly-snippets.enable = true;
    setupOpts.keymap.preset = "enter";
  };

  snippets.luasnip.enable = true;
  autopairs.nvim-autopairs.enable = true;

}
