{
  lib,
  osConfig,
  ...
}:
let
  neovimTheme = osConfig.custom.theme.current.apps.neovim or {
    name = "tokyonight";
    style = "moon";
  };
in
{
  programs.nvf.settings.vim = {
    # Statusline (lualine)
    statusline.lualine.enable = true;
    statusline.lualine.theme = lib.mkForce "auto";

    # No bufferline/tabline (user disabled this in LazyVim)
    tabline.nvimBufferline.enable = false;

    # Dashboard
    dashboard.dashboard-nvim.enable = true;

    # UI enhancements
    ui = {
      noice.enable = true;
      borders.enable = true;
      colorizer.enable = true;
      illuminate.enable = true;
    };

    # Visuals
    visuals = {
      nvim-web-devicons.enable = true;
      indent-blankline.enable = false;
      nvim-cursorline.enable = true;
      fidget-nvim.enable = true;
    };
    theme =
      {
        name = lib.mkForce neovimTheme.name;
      }
      // lib.optionalAttrs ((neovimTheme.style or null) != null) {
        style = lib.mkForce neovimTheme.style;
      };
  };
}
