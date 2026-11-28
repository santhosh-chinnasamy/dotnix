{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.desktop.quakeConsole;

  # Ghostty's Wayland app-id is fixed (com.mitchellh.ghostty), so its console
  # window is identified by the title it is spawned with. Kitty can carry a
  # real Wayland class.
  isGhostty = cfg.terminal == "ghostty";

  windowQuery =
    if isGhostty then
      ''any(.[]; .initialTitle == "Quake Console")''
    else
      ''any(.[]; .class == "quake-console")'';

  windowAddressQuery =
    if isGhostty then
      ''[.[] | select(.initialTitle == "Quake Console")][0].address // empty''
    else
      ''[.[] | select(.class == "quake-console")][0].address // empty'';

  spawnCommand =
    if isGhostty then "ghostty --title='Quake Console'" else "kitty --class=quake-console";

  quake-console = pkgs.writeShellApplication {
    name = "quake-console";
    runtimeInputs = [
      pkgs.hyprland
      pkgs.jq
      (if isGhostty then pkgs.ghostty else pkgs.kitty)
    ];
    text = ''
      # One persistent console on special:console: spawn if absent, then toggle.
      if hyprctl clients -j | jq -e '${windowQuery}' >/dev/null; then
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("console")'
        exit 0
      fi

      hyprctl dispatch "hl.dsp.exec_cmd(\"${spawnCommand}\")"

      # Wait for the window to map, then enforce the size: the terminal sends
      # its own size request after the window rule applies.
      for _ in $(seq 40); do
        hyprctl clients -j | jq -e '${windowQuery}' >/dev/null && break
        sleep 0.05
      done

      read -r w h <<<"$(hyprctl monitors -j | jq -r '.[] | select(.focused) | "\((.width / .scale * 0.7) | floor) \((.height / .scale * 0.6) | floor)"')"
      w=''${w:-1008}
      h=''${h:-540}

      addr="$(hyprctl clients -j | jq -r '${windowAddressQuery}')"

      if [ -n "$addr" ]; then
        hyprctl dispatch "hl.dsp.window.resize({ x = $w, y = $h, window = 'address:$addr' })"
        hyprctl dispatch "hl.dsp.window.center({ window = 'address:$addr' })"
      fi

      # Mapping the window can already reveal special:console; only toggle it
      # open when it is still hidden.
      if ! hyprctl monitors -j | jq -e 'any(.[]; .specialWorkspace.name == "special:console")' >/dev/null; then
        hyprctl dispatch 'hl.dsp.workspace.toggle_special("console")'
      fi
    '';
  };
in
{
  options.custom.desktop.quakeConsole.terminal = lib.mkOption {
    type = lib.types.enum [
      "ghostty"
      "kitty"
    ];
    default = "ghostty";
    description = "Terminal used for the Super+grave quake console.";
  };

  config.home.packages = [ quake-console ];
}
