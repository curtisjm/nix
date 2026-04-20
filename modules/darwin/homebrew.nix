{ ... }:
{
    homebrew = {
        enable = true;
        brews = [
            "node"
            # "sketchybar"
            "gastown"
            "gascity"
            "beads"
            "vercel-cli"
            "sentry-cli"
            "playwright-cli"
            "flock"
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
            "linear-linear"
            "t3-code"
            "codex-app"
            "cursor"
            "claude-code@latest"
            "slack"
            "warp"
            "codex"
        ];
        taps = [
            "gastownhall/gascity"
            "FelixKratz/formulae"
            "getsentry/tools"
        ];
        masApps = {
            # "Perplexity" = 6714467650;
            # "Microsoft Word" = 462054704;
            # "Microsoft Excel" = 462058435;
        };
        onActivation = {
            cleanup = "zap";
            autoUpdate = true;
            upgrade = true;
        };
    };
}
