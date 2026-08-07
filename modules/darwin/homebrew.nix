{ ... }:
{
    homebrew = {
        enable = true;
        brews = [
            "node"
            # "sketchybar"
            "vercel-cli"
            # "sentry-cli"
            "playwright-cli"
            "opencode"
            "pi-coding-agent"
            # "roborev"
            "roborev-dev/tap/roborev"
            # "herdr"
            # "hermes-agent"
            "awscli"
            # "ghosthub"
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
            "notion"
            "zen"
            "spotify"
            "forklift"
            "claude"
            "zoom"
            "linear"
            "t3-code"
            "cursor"
            "claude-code@latest"
            "slack"
            "warp"
            "zed"
            "coderabbit"
            "codex"
            "chatgpt"
            "conductor"
            "notion-calendar"
            "paper-design"
            "cmux"
            "linearmouse"
            "insomnia"
            "session-manager-plugin"
            "granola"
            "antigravity-cli"
            "kiro"
            "grok-build"
            "copilot-cli"
        ];
        taps = [
            "FelixKratz/formulae"
            # "roborev-dev/tap"
            # "kenn-io/tap"
            # "getsentry/tools"
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
