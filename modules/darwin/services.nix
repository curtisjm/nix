{ pkgs, ... }:
{
    services = {
        yabai = {
            enable = true;
            package = pkgs.yabai;
            enableScriptingAddition = true;
        };

        skhd = {
            enable = true;
            package = pkgs.skhd;
        };
    };
}
