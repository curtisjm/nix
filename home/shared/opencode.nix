{ ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      theme = "stylix";
      plugin = [
        "superpowers@git+https://github.com/obra/superpowers.git"
      ];
    };
  };
}
