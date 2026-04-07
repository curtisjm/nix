{ inputs, pkgs, lib, ... }:
let
  isLinux = pkgs.stdenv.isLinux;

  superpowersSkillsDir = inputs.superpowers + "/skills";
  superpowersSkills =
    let
      entries = builtins.readDir superpowersSkillsDir;
    in
    builtins.listToAttrs (
      map
        (name: {
          inherit name;
          value = superpowersSkillsDir + "/${name}";
        })
        (builtins.filter (name: entries.${name} == "directory") (builtins.attrNames entries))
    );

  openaiCuratedSkillsDir = inputs.openai-skills + "/skills/.curated";
  openaiSkills = {
    vercel-deploy = openaiCuratedSkillsDir + "/vercel-deploy";
    playwright = openaiCuratedSkillsDir + "/playwright";
    playwright-interactive = openaiCuratedSkillsDir + "/playwright-interactive";
    pdf = openaiCuratedSkillsDir + "/pdf";
    linear = openaiCuratedSkillsDir + "/linear";
    frontend-skill = openaiCuratedSkillsDir + "/frontend-skill";
    security-best-practices = openaiCuratedSkillsDir + "/security-best-practices";
    security-threat-model = openaiCuratedSkillsDir + "/security-threat-model";
    sentry = openaiCuratedSkillsDir + "/sentry";
  };
in
{
  home.packages = lib.mkIf isLinux [
    pkgs.playwright-driver.browsers
    pkgs.bubblewrap
  ];

  home.sessionVariables = lib.mkIf isLinux {
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
  };

  programs.codex = {
    enable = true;
    skills = superpowersSkills // openaiSkills;

    settings = {
      model = "gpt-5.4";
      model_provider = "openai";
      model_reasoning_effort = "xhigh";
      tui = {
        notifications = true;
      };
      features = {
        multi_agent = true;
      };
      mcp_servers = lib.mkIf isLinux {
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
  };
}
