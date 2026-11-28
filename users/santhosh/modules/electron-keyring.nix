# Pin Chromium/Electron apps to gnome-keyring on Hyprland (avoids "weak encryption" / basic store).
# No single OS knob covers every app: class-wide *-flags.conf + per-fork argv.json — extend below.
{ lib, ... }:
let
  passwordStoreFlag = "--password-store=gnome-libsecret";

  flagsConf = passwordStoreFlag + "\n";

  vscodeForkArgv = {
    "password-store" = "gnome-libsecret";
    "enable-crash-reporter" = false;
  };

  argvJson = builtins.toJSON vscodeForkArgv;

  # VS Code: ~/.vscode/argv.json. VSCodium: ~/.config/VSCodium/argv.json.
  # Cursor (buildVscode libraryName "cursor"): ~/.cursor/argv.json — not ~/.config/Cursor/.
  vscodeForkConfigDirs = [
    "VSCodium"
  ];
in
{
  # Session Secret Service even outside a full GNOME shell (complements host gnome-keyring).
  services.gnome-keyring.enable = true;

  home.file = {
    ".vscode/argv.json".text = argvJson;
    ".cursor/argv.json".text = argvJson;
  };

  xdg.configFile =
    lib.listToAttrs (
      map (name: {
        name = "${name}/argv.json";
        value = {
          text = argvJson;
        };
      }) vscodeForkConfigDirs
    )
    // {
      "electron-flags.conf" = {
        text = flagsConf;
      };
      "chromium-flags.conf" = {
        text = flagsConf;
      };
    };
}
