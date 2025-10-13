{ ... }:
{
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
        };

        initContent = ''
            bindkey -v
        '';
    };
}
