{ ... }:

{
  home.file.".config/atuin/config.toml".text = ''
    enter_accept = true
    search_mode = "daemon-fuzzy"
    records = true

    [sync]
    records = true

    [daemon]
    enabled = true
    autostart = true

    [ai]
    enabled = true
    model = "fast"
  '';

  }
