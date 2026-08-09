local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.default_prog = {'tmux'}

config.initial_cols = 120
config.initial_rows = 40

-- config.font = wezterm.font('Ubuntu Mono', { weight = 'Regular' })
config.font = wezterm.font('Iosevka Term', { weight = 'Regular' })
config.font_size = 16
config.freetype_load_target = 'Normal'
-- config.color_scheme = 'cyberpunk'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Sitruuna'
config.color_scheme = 'Custom'
config.color_schemes = {
  Custom = {
    foreground = '#FEFEFE',
    background = '#202020',
    cursor_bg = '#C1C88D',
    cursor_fg = '#202020',
    cursor_border = '#C1C88D',
    selection_bg = '#454545',
    selection_fg = '#FEFEFE',
    ansi = {
      '#202020', -- black
      '#C34143', -- red
      '#A2A970', -- green
      '#DEBF7C', -- yellow
      '#8B9698', -- blue
      '#AA9AAC', -- magenta
      '#6F7B68', -- cyan
      '#CCCCCC', -- white
    },
    brights = {
      '#303030',
      '#D16D6D',
      '#C1C88D',
      '#E3D896',
      '#D6D2C8',
      '#BFBBBA',
      '#8B9698',
      '#FEFEFE',
    },
  },
  Sitruuna = {
    foreground = '#d1d1d1',
    background = '#181a1b',
    cursor_bg = '#FAC03B',
    cursor_fg = '#181a1b',
    cursor_border = '#FAC03B',
    selection_bg = '#2D3032',
    selection_fg = '#d1d1d1',
    ansi = {
      '#131515',
      '#c15959',
      '#37ad82',
      '#FAC03B',
      '#7398dd',
      '#ffb354',
      '#8fbf9f',
      '#d1d1d1',
    },
    brights = {
      '#4c5356',
      '#d16d6d',
      '#4ac094',
      '#ffd166',
      '#8ab4ff',
      '#f2c66d',
      '#b8c9b8',
      '#ffffff',
    },
  },
}

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- retro: cell-based, uses terminal font; fancy (true) is the default look
config.tab_max_width = 16

return config
