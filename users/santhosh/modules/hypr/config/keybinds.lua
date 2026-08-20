local constants = require("config.constants")

local main_mod = constants.main_mod
local ipc = constants.ipc

-- Applications
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("zen"))
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd("nautilus"))

-- Window Management
hl.bind(main_mod .. " + W", hl.dsp.window.close())
hl.bind(main_mod .. " + Q", hl.dsp.exit())
hl.bind(main_mod .. " + U", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
hl.bind(main_mod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))

-- Focus
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces
for i = 1, 9 do
    hl.bind(main_mod .. " + " .. tostring(i), hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(main_mod .. " + SHIFT + " .. tostring(i), hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace " .. tostring(i)))
end
hl.bind(main_mod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind(main_mod .. " + SHIFT + 0", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace 10"))

-- Noctalia
hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd(ipc .. " launcher toggle"))
hl.bind("ALT + CTRL + C", hl.dsp.exec_cmd(ipc .. " launcher clipboard"))

-- System Key Binds (Volume & Media)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume increase"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume decrease"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume muteOutput"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. " volume muteInput"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. " media playPause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. " media next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. " media previous"))

-- Clipboard & Screenshots
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast copy screen"))
hl.bind("SHIFT + code:634", hl.dsp.exec_cmd("grimblast copy area"))

-- Full screen + notify
hl.bind("Print", hl.dsp.exec_cmd("sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save screen $FILE && notify-send \"Screenshot saved\"'"))
hl.bind("code:634", hl.dsp.exec_cmd("sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save area $FILE && notify-send \"Screenshot saved\"'"))

-- Copy / Paste (Replaces legacy bindd)
hl.bind(main_mod .. " + C", hl.dsp.send_shortcut({mods = "CONTROL", key = "Insert"}), { description = "Universal copy" })
hl.bind(main_mod .. " + V", hl.dsp.send_shortcut({mods = "SHIFT", key = "Insert"}), { description = "Universal paste" })
hl.bind(main_mod .. " + X", hl.dsp.send_shortcut({mods = "CONTROL", key = "X"}), { description = "Universal cut" })


--local constants = require("config.constants")
--hl.bind(constants.main_mod .. " + Return", hl.dsp.exec_cmd("ghostty"))