{ lib, ... }:
{
  # Offline push-to-talk / toggle dictation (Omarchy-style Voxtype).
  # Hotkeys are compositor-owned: F9 hold + Super+Ctrl+X toggle.
  services.voxtype = {
    enable = true;
    loadModels = [ "base.en" ];
    settings = {
      # Compositor owns hotkeys (F9 hold, Super+Ctrl+X toggle).
      hotkey.enabled = false;
      whisper = {
        model = "base.en";
        language = "en";
      };
      output = {
        # Type into the focused field; copy if typing fails.
        mode = "type";
        fallback_to_clipboard = true;
        notification = {
          on_recording_start = true;
          on_recording_stop = true;
          on_transcription = true;
          on_no_speech = true;
        };
      };
    };
  };

  systemd.user.services.voxtype = {
    Unit = {
      After = lib.mkForce [ "hyprland-session.target" ];
      PartOf = lib.mkForce [ "hyprland-session.target" ];
    };
    Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
  };
}
