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
            # "mactex"
            "pycharm"
            "notion"
            "zen"
            "spotify"
            "forklift"
            "claude"
            "zoom"
        ];
        taps = [
            "FelixKratz/formulae" 
        ];
        masApps = {
            # "Perplexity" = 6714467650;
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
