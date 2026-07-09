{ pkgs, ... }:
{
    services = {
        yabai = {
            enable = true;
            package = pkgs.yabai;
            enableScriptingAddition = true;
            extraConfig = builtins.readFile ../../config/yabairc;
        };

        skhd = {
            enable = true;
            package = pkgs.skhd;
        };

        # karabiner-elements = {
        #     enable = true;
        #     package = pkgs.karabiner-elements;
        # };
    };
}
