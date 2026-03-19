{ inputs, ... }:
{
  programs.codex = {
    enable = true;
    settings = {
      features = {
        multi_agent = true;
      };
    };
    skills = {
      superpowers = inputs.superpowers + "/skills";
    };
  };
}
