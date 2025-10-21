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
            # "mactex-no-gui"
        ];
        taps = [
            "FelixKratz/formulae" 
        ];
        masApps = { };
        onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
        };
    };
}
