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
    pkgs.zsh-autosuggestions
    pkgs.yazi

    # Editors and development tools.
    pkgs.neovim
    pkgs.rust-analyzer
    pkgs.typescript-language-server

    # Version control and utilities.
    pkgs.gh
    pkgs.git-lfs
    pkgs.lazygit
    pkgs.age
    pkgs.sops

    # Desktop and hardware configuration tools.
    pkgs.zed-editor
    pkgs.kanata
  ];
}
