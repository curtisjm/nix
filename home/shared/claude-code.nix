{ pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = lib.mkIf isLinux [
    pkgs.beads
    # pkgs.playwright-driver.browsers
  ];

  # home.sessionVariables = lib.mkIf isLinux {
  #   PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
  #   PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
  #   PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  # };

  # home.file.".claude/keybindings.json".text = builtins.toJSON {
  #   "$schema" = "https://www.schemastore.org/claude-code-keybindings.json";
  #   "$docs" = "https://code.claude.com/docs/en/keybindings";
  #   bindings = [
  #     {
  #       context = "Chat";
  #       bindings = {
  #         escape = null;
  #         "escape escape" = "chat:cancel";
  #       };
  #     }
  #   ];
  # };

  programs.claude-code = {
    enable = true;
    package = if isLinux then pkgs.claude-code else null;
    settings = {
      model = "opus";
      theme = "dark-ansi";
      includeCoAuthoredBy = false;
      autoCompact = false;
      skipDangerousModePermissionPrompt = true;

            permissions = {
                defaultMode = "acceptEdits";
                allow = [
                    # Tools
                    "Edit"
                    "Read"
                    "Write"
                    "Glob"
                    "Grep"
                    "WebFetch"
                    "WebSearch"

                    # Gas Town (agents call these constantly)
                    "Bash(gt *)"
                    "Bash(bd *)"

                    # Git (polecats + refinery do lots of git ops)
                    "Bash(git *)"

                    # Go toolchain
                    "Bash(go *)"
                    "Bash(make *)"

                    # Node/JS toolchain
                    "Bash(npm *)"
                    "Bash(npx *)"
                    "Bash(pnpm *)"
                    "Bash(node *)"
                    "Bash(tsc *)"
                    "Bash(eslint *)"

                    # Swift/iOS toolchain
                    "Bash(swift *)"
                    "Bash(swiftc *)"
                    "Bash(xcodebuild *)"
                    "Bash(xcrun *)"

                    # Unix utilities (agents use these heavily for exploration + scripts)
                    "Bash(ls *)"
                    "Bash(cat *)"
                    "Bash(head *)"
                    "Bash(tail *)"
                    "Bash(find *)"
                    "Bash(grep *)"
                    "Bash(sed *)"
                    "Bash(awk *)"
                    "Bash(sort *)"
                    "Bash(uniq *)"
                    "Bash(wc *)"
                    "Bash(which *)"
                    "Bash(echo *)"
                    "Bash(printf *)"
                    "Bash(mkdir *)"
                    "Bash(cp *)"
                    "Bash(mv *)"
                    "Bash(touch *)"
                    "Bash(chmod *)"
                    "Bash(diff *)"
                    "Bash(tr *)"
                    "Bash(cut *)"
                    "Bash(tee *)"
                    "Bash(xargs *)"
                    "Bash(basename *)"
                    "Bash(dirname *)"
                    "Bash(realpath *)"
                    "Bash(pwd)"
                    "Bash(date *)"
                    "Bash(hostname)"
                    "Bash(env *)"
                    "Bash(eval *)"
                    "Bash(test *)"
                    "Bash(true)"
                    "Bash(false)"
                    "Bash([ *)"
                    "Bash(jq *)"
                    "Bash(curl *)"

                    # Docker (local dev + deployment)
                    "Bash(docker *)"
                    "Bash(docker-compose *)"

                    # Fly.io deployment
                    "Bash(fly *)"
                    "Bash(flyctl *)"

                    "Bash(vercel *)"
                    "Bash(obsidian *)"
                    "Bash(playwright-cli *)"

                    # Nix
                    "Bash(nix *)"

                    # GitHub CLI
                    "Bash(gh *)"
                ];
                ask = [
                    # "Bash(git push*)"
                    # "Bash(git reset --hard*)"
                    # "Bash(rm *)"
                    # "Bash(nix-collect-garbage*)"
                ];
                deny = [
                    "Read(./.env)"
                    "Read(./secrets/**)"
                ];
            };

      extraKnownMarketplaces = {
        openai-codex = {
          source = {
            source = "github";
            repo = "openai/codex-plugin-cc";
          };
        };
        obsidian-skills = {
          source = {
            source = "github";
            repo = "kepano/obsidian-skills";
          };
        };
      };

      enabledPlugins = {
        "superpowers@claude-plugins-official" = true;
        "context7@claude-plugins-official" = true;
        "frontend-design@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        # "explanatory-output-style@claude-plugins-official" = true;
        # "learning-output-style@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "gopls-lsp@claude-plugins-official" = true;
        "swift-lsp@claude-plugins-official" = true;
        "clangd-lsp@claude-plugins-official" = true;
        "jdtls-lsp@claude-plugins-official" = true;
        "pyright-lsp@claude-plugins-official" = true;
        "lua-lsp@claude-plugins-official" = true;
        "security-guidance@claude-plugins-official" = true;
        "claude-md-management@claude-plugins-official" = true;
        "vercel@claude-plugins-official" = true;
        "linear@claude-plugins-official" = true;
        "sentry@claude-plugins-official" = true;
        "playwright@claude-plugins-official" = true;
        "codex@openai-codex" = true;
        "obsidian@obsidian-skills" = true;
      };
    };

  };
}
