{ pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        neovim
        ffmpeg
        gh
        ripgrep
        fd
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
        texliveFull
        uv
        vscode
        bat
        tldr
        btop
        # jankyborders
        shortcat
        rust-analyzer

        # Language servers
        typescript-language-server
        gopls
        pyright
        clang-tools # clangd for C/C++
        jdt-language-server
        lua-language-server
        yt-dlp
        cmake
        google-chrome
        opencode
        # claude-code  # installed via Homebrew for latest version
        utm
        telegram-desktop
    ];
}
