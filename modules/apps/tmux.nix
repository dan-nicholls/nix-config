{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    #prefix = "C-space";
    shortcut = "space";
    baseIndex = 1;
    keyMode = "vi";
    #mouse = true;
    escapeTime = 0;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      gruvbox
      yank
      vim-tmux-navigator
      #{
        #plugin = resurrect;
        #extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      #}
      #{
        #plugin = continuum;
        #extraConfig = ''
          #set -g @continuum-restore 'on'
          #set -g @continuum-save-interval '30' # minutes
          #set -g renumber-windows on
        #'';
      #}
    ];

    extraConfig = ''
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      set -g mouse on
    '';
  };
}
