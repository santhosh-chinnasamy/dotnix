{ inputs, ... }:
{
  imports = [ inputs.hex.homeManagerModules.default ];

  # Local voice dictation. Hyprland owns the hotkeys (see keybinds.lua); on
  # Hyprland Hex's own shortcut is not bound by the portal, so nothing conflicts.
  programs.hex = {
    enable = true;
    autostart = true;
    systemdTarget = "hyprland-session.target";
    # Download the default English model once the network is online.
    installModel = true;
  };
}
