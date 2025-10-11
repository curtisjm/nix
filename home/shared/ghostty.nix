{ ... }:
{
    # programs.ghostty = {
    #     enable = true;
    #
    #     settings = {
    #         background = "#1F1F28";
    #         font-family = "JetBrains Mono";
    #         font-size = 16;
    #         mouse-hide-while-typing = true;
    #         window-decoration = true;
    #         macos-option-as-alt = true;
    #         macos-titlebar-style = "hidden";
    #         theme = "Nord Wave";
    #         background-blur-radius = 25;
    #         background-opacity = 0.9;
    #     };
    # };

    home.file.".config/ghostty/config".text = ''
        background = #1F1F28
        font-family = JetBrains Mono
        font-size = 16
        mouse-hide-while-typing = true
        window-decoration = true
        macos-option-as-alt = true
        macos-titlebar-style = hidden
        theme = Nord Wave
        background-blur-radius = 25
        background-opacity = 0.9
    '';
}
