{ pkgs, ... }:

{
  home.packages = [
    # Shell and terminal tools.
    pkgs.atuin
    pkgs.ghostty
    pkgs.jujutsu
    pkgs.tmux
    pkgs.wezterm
    pkgs.zoxide
    pkgs.yazi

    # Editors and development tools.
    pkgs.neovim
    pkgs.rust-analyzer
    pkgs.typescript-language-server

    # Version control and utilities.
    pkgs.gh
    pkgs.lazygit
    pkgs.age
    pkgs.sops

    # Caveman installer. Run `caveman-install` once after switching.
    (pkgs.writeShellApplication {
      name = "caveman-install";
      runtimeInputs = [ pkgs.bash pkgs.curl pkgs.nodejs_22 ];
      text = ''
        exec curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/v2.6.0/install.sh | bash
      '';
    })

    # Desktop and hardware configuration tools.
    pkgs.zed-editor
    pkgs.kanata
  ];
}
