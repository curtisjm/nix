{ ... }:
{
    system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
    };

    system.defaults = {
        dock = { 
            autohide = true;
            persistent-apps = [ ];
            tilesize = 50;
            expose-group-apps = false;
            mru-spaces = false;
        };


        NSGlobalDomain = {
            AppleShowAllFiles = true;
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            KeyRepeat = 2;
            InitialKeyRepeat = 12;
            ApplePressAndHoldEnabled = false;
            NSAutomaticWindowAnimationsEnabled = false;
            _HIHideMenuBar = true;
        };

        CustomUserPreferences = {
            "com.apple.symbolichotkeys" = {
                AppleSymbolicHotKeys = {
                    # Disable 'Cmd + Space' for Spotlight Search
                    "64" = {
                        enabled = false;
                    };
                };
            };
        };

        loginwindow.GuestEnabled = false;
        finder.AppleShowAllExtensions = true;
        universalaccess.reduceMotion = true;
    };

    security.pam.services.sudo_local.touchIdAuth = true;
}
