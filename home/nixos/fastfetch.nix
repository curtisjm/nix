{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Fastfetch - Fast system information tool
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          top = 1;
          left = 2;
        };
      };

      display = {
        separator = " → ";
      };

      modules = [
        {
          type = "title";
          format = "{user-name}@{host-name}";
        }
        {
          type = "separator";
        }
        {
          type = "os";
          key = " OS";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = " Kernel";
          keyColor = "blue";
        }
        {
          type = "packages";
          key = "󰏗 Packages";
          keyColor = "cyan";
        }
        {
          type = "shell";
          key = " Shell";
          keyColor = "green";
        }
        {
          type = "wm";
          key = "󰨇 WM";
          keyColor = "green";
        }
        {
          type = "terminal";
          key = " Terminal";
          keyColor = "yellow";
        }
        {
          type = "separator";
        }
        {
          type = "host";
          key = "󰌢 Host";
          keyColor = "magenta";
        }
        {
          type = "cpu";
          key = "󰻠 CPU";
          keyColor = "red";
        }
        {
          type = "gpu";
          key = "󰍛 GPU";
          keyColor = "red";
        }
        {
          type = "memory";
          key = " Memory";
          keyColor = "yellow";
        }
        {
          type = "disk";
          key = "󰋊 Disk";
          keyColor = "yellow";
        }
        {
          type = "separator";
        }
        {
          type = "display";
          key = "󰍹 Display";
          keyColor = "cyan";
        }
        {
          type = "uptime";
          key = "󰔟 Uptime";
          keyColor = "magenta";
        }
        {
          type = "separator";
        }
        {
          type = "colors";
          symbol = "circle";
        }
      ];
    };
  };

  # Add fastfetch package
  home.packages = with pkgs; [
    fastfetch
  ];
}
