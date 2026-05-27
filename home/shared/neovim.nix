{
  lib,
  pkgs,
  ...
}:
let
  rWithPackages = pkgs.rWrapper.override {
    packages = with pkgs.rPackages; [
      languageserver
      lintr
      styler
    ];
  };
in
{
  stylix.targets.neovim.enable = false;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs;
      [
        # LazyVim core requirements.
        git
        curl
        unzip
        gnumake
        gcc
        tree-sitter
        ripgrep
        fd
        fzf
        lazygit
        nodejs

        # Lua and Nix editing.
        lua-language-server
        stylua
        nil
        nixd
        alejandra
        nixfmt-rfc-style
        statix
        deadnix

        # Python extra.
        python3
        pyright
        basedpyright
        ruff
        black
        isort
        python3Packages.debugpy

        # clangd, Go, R, TeX, Markdown, and general web/data formats.
        clang-tools
        cmake
        gdb
        go
        gopls
        delve
        gofumpt
        gotools
        golangci-lint
        rWithPackages
        radian
        texlab
        texliveFull
        marksman
        markdownlint-cli2
        bash-language-server
        shellcheck
        shfmt
        taplo
        typescript
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server
        prettierd
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        wl-clipboard
        xclip
      ];
  };
}
