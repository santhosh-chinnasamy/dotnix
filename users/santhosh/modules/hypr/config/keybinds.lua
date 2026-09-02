local constants = require("config.constants")

local main_mod = constants.main_mod
local ipc = constants.ipc

-- Applications
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("zen"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(main_mod .. " + I", hl.dsp.exec_cmd("codium"))

-- Window Management
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + Q", hl.dsp.exit())
hl.bind(main_mod .. " + U", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen())
-- Focus
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Workspaces
for i = 1, 9 do
    hl.bind(main_mod .. " + " .. tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(main_mod .. " + SHIFT + " .. tostring(i), hl.dsp.window.move({ workspace = tostring(i), follow = true }))
end
hl.bind(main_mod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(main_mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10, follow = true }))


local shell = constants.shell

-- Universal Copy / Paste
hl.bind(main_mod .. " + C", hl.dsp.send_shortcut({mods = "CONTROL", key = "Insert"}), { description = "Universal copy" })
hl.bind(main_mod .. " + V", hl.dsp.send_shortcut({mods = "SHIFT", key = "Insert"}), { description = "Universal paste" })
hl.bind(main_mod .. " + X", hl.dsp.send_shortcut({mods = "CONTROL", key = "X"}), { description = "Universal cut" })

if shell == "dms" then
  -- Dank Material Shell Core Binds
  hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd(ipc .. "spotlight toggle"))
  hl.bind("ALT + Space", hl.dsp.exec_cmd(ipc .. "spotlight-bar toggle"))
  hl.bind(main_mod .. " + S", hl.dsp.exec_cmd(ipc .. "settings focusOrToggle"))
  hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings focusOrToggle"))
  hl.bind(main_mod .. " + N", hl.dsp.exec_cmd(ipc .. "notifications toggle"))
  hl.bind("ALT + F4", hl.dsp.exec_cmd(ipc .. "powermenu toggle"))
  hl.bind(main_mod .. "+ ALT + C", hl.dsp.exec_cmd(ipc .. "clipboard toggle"))
  hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "hypr toggleOverview"))
  hl.bind(main_mod .. " + Tab", hl.dsp.exec_cmd(ipc .. "hypr toggleOverview"))
  hl.bind(main_mod .. " + O", hl.dsp.exec_cmd(ipc .. "hypr toggleOverview"))

  -- Media & Brightness (DMS)
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "audio increment 3"), { locked = true, repeating = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "audio decrement 3"), { locked = true, repeating = true })
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "audio mute"), { locked = true })
  hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "audio micmute"), { locked = true })
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), { locked = true, repeating = true })

  -- Media Playback
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "mpris playPause"), { locked = true })
  hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "mpris playPause"), { locked = true })
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "mpris next"), { locked = true })
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "mpris previous"), { locked = true })

  -- Screenshots (DMS)
  hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
  hl.bind("SHIFT + Print", hl.dsp.exec_cmd("dms screenshot full"))
  hl.bind("ALT + Print", hl.dsp.exec_cmd("dms screenshot window"))

elseif shell == "noctalia" then
  -- Noctalia Core Binds
  hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
  hl.bind(main_mod .. " + S", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
  hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
  hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))
  hl.bind(main_mod .. "+ Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"))

  -- Media & Brightness (Noctalia)
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
  hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

  -- Media Playback
  hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
  hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
  hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

  -- Clipboard & Screenshots
  hl.bind("SHIFT + Print", hl.dsp.exec_cmd("sh -c grimblast copy screen && notify-send \"Copied Screen\""))
  hl.bind("SHIFT + code:634", hl.dsp.exec_cmd("grimblast copy area"))
  hl.bind("Print", hl.dsp.exec_cmd("sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save screen $FILE && notify-send \"Screenshot saved\"'"))
  hl.bind("code:634", hl.dsp.exec_cmd("sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save area $FILE && notify-send \"Screenshot saved\"'"))
end

