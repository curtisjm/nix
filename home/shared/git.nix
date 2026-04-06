{ pkgs, ... }:
{
  home.packages = [
    pkgs.gh
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Curtis Mitchell";
      user.email = "70792951+curtisjm@users.noreply.github.com";
      pull.rebase = false;
    };
  };
}
