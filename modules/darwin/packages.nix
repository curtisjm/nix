{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        neovim
        ffmpeg
        # git
        gh
        # tmux
        ripgrep
        # aerospace
        fd
        # fzf
        go
        python3
        ruff
        nil
        cargo
        rustc
        docker
        docker-compose
        colima
        stow
        skimpdf
        tree
        uv
        vscode
        bat
        # zoxide
        # zsh-autocomplete
        # zsh-autosuggestions
        # eza
        # atuin
        tldr
        neofetch
        btop
        jq
        jankyborders
        shortcat
    ];
}
