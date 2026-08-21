{
  pkgs,
  lib,
  osConfig,
  hostConfig,
  ...
}:
let
  transparency = osConfig.custom.theme.transparency or false;
  theme = osConfig.custom.theme.current or { };
  hyprTheme = theme.hyprland or { };
  animationsEnabled = hyprTheme.animations.enabled or true;

  monitorFromHyprlang =
    monitor:
    let
      parts = lib.splitString ", " monitor;
    in
    {
      output = lib.elemAt parts 0;
      mode = lib.elemAt parts 1;
      position = lib.elemAt parts 2;
      scale = lib.elemAt parts 3;
    };

  mkBezier = name: p1: p2: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          p1
          p2
        ];
      }
    ];
  };
in
{
  imports = [
    ./swappy.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp

    wl-clipboard
    cliphist
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    settings = {
      on = {
        _args = [
          "hyprland.start"
          (lib.generators.mkLuaInline ''
            function()
              hl.exec_cmd("noctalia")
            end
          '')
        ];
      };

      monitor = map monitorFromHyprlang hostConfig.monitors;

      env = lib.optionals hostConfig.hasNvidia [
        {
          _args = [
            "LIBVA_DRIVER_NAME"
            "nvidia"
          ];
        }
        {
          _args = [
            "XDG_SESSION_TYPE"
            "wayland"
          ];
        }
        {
          _args = [
            "GBM_BACKEND"
            "nvidia-drm"
          ];
        }
        {
          _args = [
            "__GLX_VENDOR_LIBRARY_NAME"
            "nvidia"
          ];
        }
      ];

      config = {
        input = {
          follow_mouse = 1;
          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
          scroll_factor = 0.8;

          repeat_rate = 50;
          repeat_delay = 300;
        }
        // lib.optionalAttrs hostConfig.isLaptop {
          touchpad = {
            natural_scroll = true;
            # clickfinger_behavior = true;
          };
        };

        general = {
          gaps_in = hyprTheme.gapsIn or 5;
          gaps_out = hyprTheme.gapsOut or 10;
          border_size = hyprTheme.borderSize or 2;
        };

        decoration = {
          rounding = hyprTheme.rounding or 6;
          rounding_power = hyprTheme.roundingPower or 3;

          active_opacity = if transparency then (hyprTheme.activeOpacity or 0.82) else 1.0;
          inactive_opacity = if transparency then (hyprTheme.inactiveOpacity or 0.75) else 1.0;
          fullscreen_opacity = hyprTheme.fullscreenOpacity or 1.0;

          shadow = {
            enabled = hyprTheme.shadow.enabled or true;
            range = hyprTheme.shadow.range or 20;
            render_power = hyprTheme.shadow.renderPower or 2;
            offset = hyprTheme.shadow.offset or "0 5";
            # color = hyprTheme.shadow.color or "rgba(00000055)";
          };

          blur = {
            enabled = transparency && (hyprTheme.blur.enabled or true);
            size = hyprTheme.blur.size or 10;
            passes = hyprTheme.blur.passes or 3;
            noise = hyprTheme.blur.noise or 0.04;
            contrast = hyprTheme.blur.contrast or 1.0;
            brightness = hyprTheme.blur.brightness or 1.0;
            vibrancy = hyprTheme.blur.vibrancy or 0.15;
            vibrancy_darkness = hyprTheme.blur.vibrancyDarkness or 0.5;
            new_optimizations = hyprTheme.blur.newOptimizations or true;
            popups = hyprTheme.blur.popups or true;
          };
        };

        animations = {
          enabled = animationsEnabled;
        };

        dwindle = {
          preserve_split = true;
          force_split = 2; # always split to the right/bottom
        };
      };

      curve = [
        (mkBezier "overshot"
          [
            0.05
            0.9
          ]
          [
            0.1
            1.1
          ]
        )
        (mkBezier "smoothOut"
          [
            0.33
            1
          ]
          [
            0.68
            1
          ]
        )
        (mkBezier "snappy"
          [
            0.25
            0.46
          ]
          [
            0.45
            0.94
          ]
        )
      ];

      animation = [
        {
          leaf = "global";
          enabled = animationsEnabled;
          speed = 6;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = animationsEnabled;
          speed = 5;
          bezier = "smoothOut";
        }
        {
          leaf = "windows";
          enabled = animationsEnabled;
          speed = 4;
          bezier = "overshot";
        }
        {
          leaf = "windowsIn";
          enabled = animationsEnabled;
          speed = 4;
          bezier = "overshot";
          style = "popin 85%";
        }
        {
          leaf = "windowsOut";
          enabled = animationsEnabled;
          speed = 3;
          bezier = "smoothOut";
          style = "popin 95%";
        }
        {
          leaf = "fadeIn";
          enabled = animationsEnabled;
          speed = 2;
          bezier = "smoothOut";
        }
        {
          leaf = "fadeOut";
          enabled = animationsEnabled;
          speed = 2;
          bezier = "smoothOut";
        }
        {
          leaf = "fade";
          enabled = animationsEnabled;
          speed = 3;
          bezier = "snappy";
        }
        {
          leaf = "layers";
          enabled = animationsEnabled;
          speed = 3;
          bezier = "smoothOut";
        }
        {
          leaf = "layersIn";
          enabled = animationsEnabled;
          speed = 3;
          bezier = "overshot";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = animationsEnabled;
          speed = 2;
          bezier = "smoothOut";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = animationsEnabled;
          speed = 2;
          bezier = "smoothOut";
        }
        {
          leaf = "fadeLayersOut";
          enabled = animationsEnabled;
          speed = 2;
          bezier = "smoothOut";
        }
        {
          leaf = "workspaces";
          enabled = false;
        }
        {
          leaf = "workspacesIn";
          enabled = false;
        }
        {
          leaf = "workspacesOut";
          enabled = false;
        }
      ];

      # Layer rules for noctalia shell blur
      layer_rule = [
        {
          name = "noctalia";
          match.namespace = "^noctalia.*$";
          blur = true;
        }
        {
          name = "noctalia-background";
          match.namespace = "noctalia-background-.*$";
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      ];

      # Make certain windows fully opaque
      window_rule = [
        {
          match.class = "^(firefox)$";
          opacity = "1.0 override";
        }
        {
          match.class = "^(zen)$";
          opacity = "1.0 override";
        }
        {
          match.class = "^(mpv)$";
          opacity = "1.0 override";
        }
        {
          match.fullscreen = true;
          opacity = "1.0 override";
        }
      ];
    }
    // lib.optionalAttrs hostConfig.isLaptop {
      device = {
        name = "tpps/2-elan-trackpoint";
        accel_profile = "flat";
        sensitivity = -0.2;
      };
    };

    extraConfig = ''
      local mainMod = "SUPER"
      local terminal = "kitty"
      local fileManager = "thunar"
      local browser = "zen"

      local function run(cmd)
        return hl.dsp.exec_cmd(cmd)
      end

      hl.bind(mainMod .. " + Return", run(terminal))
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())

      local workspaces = {
        ["1"] = 1,
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["0"] = 10,
        T = 11,
        B = 12,
        A = 13,
        D = 14,
        C = 15,
        S = 15,
        O = 16,
        V = 17,
        E = 18,
        G = 19,
      }

      for key, workspace in pairs(workspaces) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
      end

      local directions = {
        h = "left",
        j = "down",
        k = "up",
        l = "right",
        left = "left",
        right = "right",
        up = "up",
        down = "down",
      }

      for key, direction in pairs(directions) do
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
      end

      for key, direction in pairs({ h = "left", j = "down", k = "up", l = "right" }) do
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
      end

      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(0))
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))

      hl.bind(mainMod .. " + SPACE", run("noctalia ipc call launcher toggle"))
      hl.bind(mainMod .. " + X", run("noctalia ipc call launcher clipboard"))

      hl.bind("Print", run([=[grim -g "$(slurp)" - | swappy -f - ; noctalia ipc call toast send '{"title": "Screenshot", "body": "Region captured", "icon": "camera", "duration": 1000}']=]))
      hl.bind("SHIFT + Print", run([=[grim - | swappy -f - ; noctalia ipc call toast send '{"title": "Screenshot", "body": "Screen captured", "icon": "camera", "duration": 1000}']=]))

      hl.bind("CTRL + SHIFT + " .. mainMod .. " + L", run("loginctl lock-session"))

      hl.bind(mainMod .. " + ALT + t", run(terminal))
      hl.bind(mainMod .. " + ALT + b", run(browser))
      hl.bind(mainMod .. " + ALT + o", run("obsidian"))
      hl.bind(mainMod .. " + ALT + e", run(fileManager))
      hl.bind(mainMod .. " + ALT + v", run("virt-manager"))
      hl.bind(mainMod .. " + ALT + d", run("vesktop"))

      hl.bind("XF86AudioMute", run("noctalia ipc call volume muteOutput"), { locked = true })

      hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
      hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })

      hl.bind("XF86AudioRaiseVolume", run("noctalia ipc call volume increase"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", run("noctalia ipc call volume decrease"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp", run("noctalia ipc call brightness increase"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", run("noctalia ipc call brightness decrease"), { locked = true, repeating = true })
    ''
    + lib.optionalString hostConfig.isLaptop ''
      hl.bind("switch:Lid Switch", run("systemctl suspend"), { locked = true })
    '';
  };

  services.hyprpolkitagent.enable = true;
}
