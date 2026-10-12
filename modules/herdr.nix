{ ... }:

{
  home.file.".config/herdr/config.toml".text = ''
    onboarding = false

    [theme]
    name = "terminal"

    [keys]
    prefix = "ctrl+a"
    split_vertical = "prefix+%"
    split_horizontal = "prefix+minus"
    focus_pane_left = "ctrl+h"
    focus_pane_down = "ctrl+j"
    focus_pane_up = "ctrl+k"
    focus_pane_right = "ctrl+l"

    [experimental]
    kitty_graphics = true

    [ui]
    agent_panel_sort = "priority"
  '';
}
