{ pkgs, ... }:
{
    programs.tmux = {
        enable = true;
        # shell = "${pkgs.zsh}/bin/zsh";
        terminal = "screen-256color";
        historyLimit = 1000000;
        baseIndex = 1;
        escapeTime = 0;
        keyMode = "vi";
        mouse = true;
        prefix = "C-a";

        plugins = with pkgs.tmuxPlugins; [
            sensible
            yank
        ];

        extraConfig = ''
      # Terminal color settings
      set -g default-command ${pkgs.zsh}/bin/zsh
      set-option -g terminal-overrides ',xterm-256color:RGB'

      # Additional prefix binding
      set -g prefix ^A
      bind-key C-a send-prefix

      # Tmux settings
      set -g detach-on-destroy off     # don't exit from tmux when closing a session
      set -g renumber-windows on       # renumber all windows when any window is closed
      set -g set-clipboard on          # use system clipboard
      set -g status-position top       # macOS / darwin style

      # Status bar off
      set -g status off

      # Vi mode copy settings
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection
      unbind -T copy-mode-vi MouseDragEnd1Pane

      # Vim-like pane switching (optional - uncomment if you want)
      # bind -r ^ last-window
      # bind -r k select-pane -U
      # bind -r j select-pane -D
      # bind -r h select-pane -L
      # bind -r l select-pane -R
        '';
    };
}
