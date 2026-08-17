local mod = "SUPER"

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar --config /etc/xdg/waybar/config --style /etc/xdg/waybar/style.css")
end)

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.config({
    input = {
        kb_layout = "au",
    },

    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 1,
    },
})

-- Basic Keybinds
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))

-- Change Workspace
hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = 9 }))

-- Move Workspace
for workspace = 1, 9 do
    hl.bind(mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

-- Focus Window
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Move Window
hl.bind(mod .. " + SHIFT + H", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mod .. " + SHIFT + K", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mod .. " + SHIFT + J", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Resize Window
hl.bind(mod .. " + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -50 0"))
hl.bind(mod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 50 0"))
hl.bind(mod .. " + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -50"))
hl.bind(mod .. " + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 50"))
