{ pkgs, ...}: {
    home.username = "santhosh";
    home.homeDirectory = "/home/santhosh";
    home.stateVersion = "25.11";

    home.packages = with pkgs; [
    telegram-desktop
    ghostty
    ];

    programs.git = {
        enable = true;
        userName = "Santhosh C";
        userEmail = "csesanthosh15@gmail.com";
      };

    programs.home-manager.enable = true;
  }
