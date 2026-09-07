{ ... }:

{
  home.username = "amaan";
  home.homeDirectory = "/home/amaan";
  home.stateVersion = "26.05";

  imports = [
    ./modules
  ];

  programs.home-manager.enable = true;
}
