{...}: {
  programs.obsidian = {
    enable = true;
    cli.enable = true;
  };
  home.file = {
    "CJM/.obsidian.vimrc" = {
      source = ../../config/.obsidian.vimrc;
    };
  };
}
