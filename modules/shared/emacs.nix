{pkgs, ...}:
let
  # Tree-sitter grammars for Emacs 30 built-in treesit
  treesitGrammars = pkgs.emacsPackages.treesit-grammars.with-grammars (grammars: with grammars; [
    tree-sitter-typescript
    tree-sitter-tsx
    tree-sitter-javascript
    tree-sitter-python
    tree-sitter-json
    tree-sitter-yaml
    tree-sitter-bash
    tree-sitter-c
    tree-sitter-cpp
    tree-sitter-go
    tree-sitter-rust
    tree-sitter-lua
    tree-sitter-nix
  ]);
in
{
  environment.systemPackages = with pkgs; [
    # required dependencies
    git
    # TODO: add check for if this system is running wayland
    emacs-pgtk
    ripgrep
    # optional dependencies
    coreutils # basic GNU utilities
    fd
    clang

    # Tree-sitter grammars (Emacs 30 treesit)
    treesitGrammars

    # TypeScript
    typescript
    typescript-language-server

    # Shell
    shellcheck
    shfmt

    # Python
    black
    isort
    python3Packages.pyflakes
    python3Packages.pytest

    # Go (if using Go)
    gopls
    gomodifytags
    gotests
    gore

    # C/C++/Java
    clang-tools # includes clang-format
    jdk

    # Other
    nixfmt
    libxml2 # includes xmllint
    pandoc # for markdown preview
  ];

  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };
}
# git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
# ~/.emacs.d/bin/doom install

