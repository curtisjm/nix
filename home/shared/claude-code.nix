{ pkgs, ... }:
{
  home.packages = [
    pkgs.playwright-driver.browsers
    pkgs.beads
  ];

  home.sessionVariables = {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  programs.claude-code = {
    enable = true;
    settings = {
      model = "opus";
      theme = "dark-ansi";
      # includeCoAuthoredBy = false;
      autoCompact = false;

      permissions = {
        defaultMode = "acceptEdits";
        allow = [
          "Edit"
          "Bash(git *)"
          "Bash(npm test*)"
          "Bash(npm run *)"
          "Bash(npx *)"
          "Bash(nix *)"
          "Bash(ls *)"
          "Bash(which *)"
          "WebFetch"
        ];
        ask = [
          "Bash(git push*)"
          "Bash(rm *)"
          "Bash(nix-collect-garbage*)"
        ];
        deny = [
          "Read(./.env)"
          "Read(./secrets/**)"
        ];
      };

      # extraKnownMarketplaces = {
      #   superpowers-marketplace = {
      #     source = {
      #       source = "github";
      #       repo = "obra/superpowers-marketplace";
      #     };
      #   };
      # };

      enabledPlugins = {
        "superpowers@claude-plugins-official" = true;
        "context7@claude-plugins-official" = true;
        "frontend-design@claude-plugins-official" = true;
        "code-review@claude-plugins-official" = true;
        # "explanatory-output-style@claude-plugins-official" = true;
        "learning-output-style@claude-plugins-official" = true;
        "typescript-lsp@claude-plugins-official" = true;
        "security-guidance@claude-plugins-official" = true;
        "claude-md-management@claude-plugins-official" = true;
        "vercel@claude-plugins-official" = true;
        "linear@claude-plugins-official" = true;
      };
    };

    mcpServers = {
      playwright = {
        command = "npx";
        args = [
          "-y"
          "@playwright/mcp"
          "--executable-path"
          "${pkgs.google-chrome}/bin/google-chrome-stable"
        ];
      };
    };
  };
}
