{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cat = "bat";
      ls = "eza";
      grep = "rg";
      fzf = ''fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'';
      clear = "command clear && fastfetch";
    };

    initContent = ''
      bindkey -v
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export PATH="/Library/TeX/texbin:$PATH"
      export PATH="$HOME/.emacs.d/bin:$PATH"
      export GASTOWN_DISABLE_OFFER_ADD=1
      cd() {
        z "$@"
        eza -l
      }
      fastfetch
    '';
  };
}
