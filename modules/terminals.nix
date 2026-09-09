{ ... }:

{
  home.file.".config/ghostty/config".text = ''
    command=/bin/zsh
    adjust-cell-height = 10%
    background-blur-radius = 60
    background-opacity = 1.00
    bold-is-bright = false
    confirm-close-surface = false
    cursor-style = bar
    font-family = "Iosevka Term"
    font-size = 12
    gtk-single-instance = true
    mouse-hide-while-typing = true
    quick-terminal-position = center
    selection-background = #2d3f76
    selection-foreground = #c8d3f5
    shell-integration = detect
    shell-integration-features = cursor,sudo
    term = xterm-256color
    title = GhosTTY
    unfocused-split-opacity = 0.5
    wait-after-command = false
    window-height = 60
    window-save-state = always
    window-theme = dark
    window-width = 130
    theme = Atom One Dark
  '';

  home.file.".config/ghostty/auto/theme.ghostty".text = ''
    theme = Catppuccin Macchiato
  '';

  home.file.".config/ghostty/themes/catppuccin-macchiato".text = ''
    foreground = #cad3f5
    background = #24273a
    cursor-color = #f4dbd6
    cursor-text = #24273a
    selection-foreground = #cad3f5
    selection-background = #5b6078
    palette = 0=#494d64
    palette = 1=#ed8796
    palette = 2=#a6da95
    palette = 3=#eed49f
    palette = 4=#8aadf4
    palette = 5=#f5bde6
    palette = 6=#8bd5ca
    palette = 7=#b8c0e0
    palette = 8=#5b6078
    palette = 9=#ed8796
    palette = 10=#a6da95
    palette = 11=#eed49f
    palette = 12=#8aadf4
    palette = 13=#f5bde6
    palette = 14=#8bd5ca
    palette = 15=#a5adcb
  '';

  home.file.".config/ghostty/themes/custom".text = ''
    foreground = #FEFEFE
    background = #202020
    cursor-color = #C1C88D
    cursor-text = #202020
    selection-background = #454545
    selection-foreground = #FEFEFE
    palette = 0=#202020
    palette = 1=#C34143
    palette = 2=#A2A970
    palette = 3=#DEBF7C
    palette = 4=#8B9698
    palette = 5=#AA9AAC
    palette = 6=#6F7B68
    palette = 7=#CCCCCC
    palette = 8=#303030
    palette = 9=#D16D6D
    palette = 10=#C1C88D
    palette = 11=#E3D896
    palette = 12=#D6D2C8
    palette = 13=#BFBBBA
    palette = 14=#8B9698
    palette = 15=#FEFEFE
  '';

  home.file.".config/ghostty/wallust.conf".text = ''
    foreground = #EAD2CD
    background = #272227
    cursor-color = #AD8CB1
    selection-foreground = #EAD2CD
    selection-background = #D8649A
    palette = 0=#4D484D
    palette = 1=#251526
    palette = 2=#543570
    palette = 3=#543571
    palette = 4=#A24B74
    palette = 5=#A24B74
    palette = 6=#935F53
    palette = 7=#D9B7AF
    palette = 8=#98807A
    palette = 9=#321C32
    palette = 10=#704696
    palette = 11=#704696
    palette = 12=#D8649A
    palette = 13=#D8649A
    palette = 14=#C47F6F
    palette = 15=#D9B7AF
  '';

  home.file.".tmux.conf".text = ''
    set -g prefix C-a
    unbind C-b
    bind-key C-a send-prefix
    set -g escape-time 0
    set -g extended-keys on
    set -g repeat-time 1000
    set -g history-limit 10000
    set -g detach-on-destroy off
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"
    bind f display-popup -E -w 80% -h 80% -d "#{pane_current_path}" -b rounded -S "fg=#fe8019" -T " floating shell "
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
    vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +''${vim_pattern}$'"
    bind-key -n 'C-h' if-shell "''${is_vim}" 'send-keys C-h' 'select-pane -L'
    bind-key -n 'C-j' if-shell "''${is_vim}" 'send-keys C-j' 'select-pane -D'
    bind-key -n 'C-k' if-shell "''${is_vim}" 'send-keys C-k' 'select-pane -U'
    bind-key -n 'C-l' if-shell "''${is_vim}" 'send-keys C-l' 'select-pane -R'
    bind-key -T copy-mode-vi 'C-h' select-pane -L
    bind-key -T copy-mode-vi 'C-j' select-pane -D
    bind-key -T copy-mode-vi 'C-k' select-pane -U
    bind-key -T copy-mode-vi 'C-l' select-pane -R
    setw -g mode-keys vi
    set -g status-keys vi
    set -g mouse on
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "win32yank.exe -i --crlf"
    set -g base-index 1
    set -g pane-base-index 1
    set -g renumber-windows on
    bind r source-file ~/.tmux.conf
    bind c new-window -c "#{pane_current_path}"
    bind n next-window
    bind p previous-window
    bind w list-windows
    set -g default-terminal "''${TERM}"
    set -sg terminal-overrides ",*:RGB"
    set -g focus-events on
    set -g status-position top
    set -g status-style "bg=#1c1c1c,fg=#a8a8a8"
    set -g status-justify left
    set -g status-left-length 0
    set -g status-right-length 40
    set -g status-left ""
    set -g window-status-separator " "
    set -g window-status-format " #I:#W#F "
    set -g window-status-current-format " #I:#W#F "
    set -g window-status-style "bg=#1c1c1c,fg=#a8a8a8"
    set -g window-status-current-style "bg=#303030,fg=#eeeeee,bold"
    set -g status-right "#[bg=#b2b2b2,fg=#1c1c1c,bold] #{b:pane_current_path} "
    set -g pane-border-lines single
    set -g pane-border-status off
    set -g pane-border-style fg=#665c54
    set -g pane-active-border-style fg=#a89984
  '';

  home.file.".wezterm.lua".text = ''
    local wezterm = require 'wezterm'
    local config = {}
    if wezterm.config_builder then
      config = wezterm.config_builder()
    end
    config.initial_cols = 120
    config.initial_rows = 40
    config.font = wezterm.font('Iosevka Term', { weight = 'Regular' })
    config.font_size = 16
    config.freetype_load_target = 'Normal'
    config.color_scheme = 'Gruvbox'
    config.color_schemes = {
      Gruvbox = {
        foreground = '#FEFEFE',
        background = '#202020',
        cursor_bg = '#C1C88D',
        cursor_fg = '#202020',
        cursor_border = '#C1C88D',
        selection_bg = '#454545',
        selection_fg = '#FEFEFE',
        ansi = { '#202020', '#C34143', '#A2A970', '#DEBF7C', '#8B9698', '#AA9AAC', '#6F7B68', '#CCCCCC' },
        brights = { '#303030', '#D16D6D', '#C1C88D', '#E3D896', '#D6D2C8', '#BFBBBA', '#8B9698', '#FEFEFE' },
      },
    }
    config.hide_tab_bar_if_only_one_tab = true
    config.use_fancy_tab_bar = false
    config.tab_max_width = 16
    return config
  '';
}
