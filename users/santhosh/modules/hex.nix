{
  inputs,
  lib,
  ...
}:
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
    settings = {
      # Vulkan batch transcription is ~4x faster than CPU on this iGPU
      # (909 ms vs 3770 ms for 13 s of audio). The live streaming path is
      # broken on the Intel Arc (ARL) iGPU: it produces no partials, misses
      # its deadline and can return empty text, so streaming is disabled below.
      transcription_device = "gpu";
      # Kept in sync with the Hyprland binds; Hyprland itself ignores these and
      # delivers the keys from keybinds.lua.
      dictation_hotkey = "alt+space";
      "capture.hotkey" = "f12";
    };
  };

  # Whole-clip transcription only. Upstream reports and local logs agree that
  # the Intel iGPU cannot stream Parakeet Unified English in real time
  # (see hex issue #484 for the slow-iGPU deadline case and #458 for the
  # streaming pause cap). Batch transcription on Vulkan is unaffected.
  systemd.user.services.hex.Service.Environment = lib.mkAfter [ "HEX_STREAMING=0" ];

  # Hex's compositor shortcuts are delivered through the portal's
  # GlobalShortcuts session, which dies when the portal restarts (and the
  # compositor binds then point at nothing). Restart Hex with the portal so the
  # shortcuts re-register automatically.
  systemd.user.services.hex.Unit = {
    After = lib.mkAfter [
      "xdg-desktop-portal.service"
      "xdg-desktop-portal-hyprland.service"
    ];
    PartOf = lib.mkAfter [
      "xdg-desktop-portal.service"
      "xdg-desktop-portal-hyprland.service"
    ];
  };
}
