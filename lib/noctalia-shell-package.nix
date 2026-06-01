{ inputs, pkgs }:

inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
  postPatch = (old.postPatch or "") + ''
    sed -i '/property string density: "default" \/\/ "compact", "default", "comfortable"/ {
      N
      s/property string density: "default" \/\/ "compact", "default", "comfortable"\n    }/property string density: "default" \/\/ "compact", "default", "comfortable"\n      property bool animationDisabled: false\n    }/
    }' Commons/Settings.qml

    substituteInPlace Modules/Panels/Launcher/LauncherCore.qml \
      --replace 'readonly property bool animationsDisabled: Settings.data.general.animationDisabled' 'readonly property bool animationsDisabled: Settings.data.general.animationDisabled || Settings.data.appLauncher.animationDisabled' \
      --replace 'duration: Style.animationFast' 'duration: root.animationsDisabled ? 0 : Style.animationFast'

    substituteInPlace Modules/Panels/Launcher/Launcher.qml \
      --replace 'duration: Style.animationFast' 'duration: (Settings.data.general.animationDisabled || Settings.data.appLauncher.animationDisabled) ? 0 : Style.animationFast'

    substituteInPlace Modules/Panels/Launcher/LauncherOverlayWindow.qml \
      --replace 'duration: Style.animationNormal' 'duration: (Settings.data.general.animationDisabled || Settings.data.appLauncher.animationDisabled) ? 0 : Style.animationNormal' \
      --replace 'duration: Style.animationFast' 'duration: (Settings.data.general.animationDisabled || Settings.data.appLauncher.animationDisabled) ? 0 : Style.animationFast'
  '';
})
