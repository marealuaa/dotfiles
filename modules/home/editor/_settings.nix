{
  vim = {
    viAlias = true;
    vimAlias = true;

    theme = import ./settings/_theme.nix { inherit self; }
  };
}
