{ ... }:
{
    homebrew = {
        enable = true;
        brews = [
            "node"
            "sketchybar"
        ];
        casks = [
            "arc"
            "discord"
            "obsidian"
            "karabiner-elements"
            "ghostty"
            "raycast"
            "proton-pass"
            "protonvpn"
            "parallels"
            "mactex"
            "pycharm"
            "notion"
            "protonvpn"
            "zen"
            "spotify"
            "forklift"
            "claude"
            "claude-code"
            # "mactex-no-gui"
        ];
        taps = [
            "FelixKratz/formulae" 
        ];
        masApps = {
            "Perplexity" = 6714467650;
            "Microsoft Word" = 462054704;
            "Microsoft Excel" = 462058435;
        };
        onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
        };
    };
}
