local function bind(keys, dispatch, opts)
	hl.bind(keys, dispatch, opts)
end

local function bind_cmd(keys, cmd, opts)
	hl.bind(keys, hl.dsp.exec_cmd(cmd), opts)
end

local function toggle_rofi(cmd)
	return "pkill rofi || " .. cmd
end

local HOME = os.getenv("HOME")

local mainMod = "SUPER"
local secondMod = "SUPER + SHIFT"
local thirdMod = "SUPER + CTRL"

local prefix = "uwsm-app -- "

local terminal = prefix .. "ghostty +new-window"
local browser = prefix .. "flatpak run app.zen_browser.zen"
local fileManager = prefix .. "nautilus -w"
local menu = toggle_rofi("rofi -show drun -run-command \"uwsm-app -- {cmd}\"")

hl.config({
	binds = {
		scroll_event_delay = 200,
		hide_special_on_workspace_change = true,
	},
})

-- App
bind_cmd(mainMod .. " + return", terminal)
bind_cmd(mainMod .. " + B", browser)
bind_cmd(mainMod .. " + E", fileManager)
bind_cmd(mainMod .. " + D", menu)
bind_cmd(secondMod .. " + D", prefix .. "flatpak run dev.vencord.Vesktop")
bind_cmd("CTRL + SHIFT + escape", prefix .. "flatpak run net.nokyan.Resources")

bind_cmd(mainMod .. " + escape", "hyprlock")
bind_cmd("ALT + escape", "hyprlock -c " .. HOME .. "/.config/hypr/hyprlock.login.conf")
bind_cmd(mainMod .. " + C", "hyprpicker -a")
bind_cmd(mainMod .. " + equal", "pkill woomer || woomer")
bind_cmd(secondMod .. " + B", "pkill -SIGUSR1 waybar")
bind_cmd(mainMod .. " + N", "swaync-client -t")

bind_cmd(secondMod .. " + escape", toggle_rofi("power-menu"))
bind_cmd(mainMod .. " + P", toggle_rofi("power-profile-menu"))
bind_cmd(mainMod .. " + V", toggle_rofi("cliphist list | rofi -dmenu -theme-str 'window {width: 50%;}' | cliphist decode | wl-copy"))
bind_cmd(mainMod .. " + W", "wallpaper-picker")

-- screenshot
bind_cmd("Print", "screenshot --copy")
bind_cmd(mainMod .. " + Print", "screenshot --save")

-- OCR
bind_cmd(mainMod .. " + O", "ocr")

-- Window
bind(mainMod .. " + Q", 	hl.dsp.window.close())
bind(mainMod .. " + space", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + F", 	hl.dsp.window.fullscreen({ action = "toggle" }))
bind(secondMod .. " + F",   hl.dsp.window.fullscreen({ mode = 1 }))

for _, d in ipairs({
    { key = "H", arrow = "LEFT",  dir = "l", x = -100, y = 0 },
    { key = "L", arrow = "RIGHT", dir = "r", x = 100,  y = 0 },
    { key = "K", arrow = "UP",    dir = "u", x = 0,    y = -100 },
    { key = "J", arrow = "DOWN",  dir = "d", x = 0,    y = 100 },
}) do
    -- Focus
    bind(mainMod .. " + " .. d.key, hl.dsp.focus({ direction = d.dir }))
    bind(mainMod .. " + " .. d.arrow, hl.dsp.focus({ direction = d.dir }))
    -- Move window
    bind(secondMod .. " + " .. d.key, hl.dsp.window.move({ direction = d.dir }))
    bind(secondMod .. " + " .. d.arrow, hl.dsp.window.move({ direction = d.dir }))
    -- Resize window
    bind(thirdMod .. " + " .. d.key, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }))
    bind(thirdMod .. " + " .. d.arrow, hl.dsp.window.resize({ x = d.x, y = d.y, relative = true }))
end

bind(mainMod .. " + U", hl.dsp.layout("togglesplit"))

bind("CTRL + ALT + UP", hl.dsp.focus({ window = "floating" }))
bind("CTRL + ALT + DOWN", hl.dsp.focus({ window = "tiled" }))

bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Workspace
for i = 1, 10 do
    local key = i % 10
    bind(mainMod   .. " + " .. key, hl.dsp.focus({ workspace = i }))
    bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

bind(mainMod .. " + S",   hl.dsp.workspace.toggle_special("magic"))
bind(secondMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Action
bind(secondMod .. " + CTRL + M", hl.dsp.exec_cmd("uwsm stop"))

-- multimedia keys
bind(mainMod .. " + f11", hl.dsp.exec_cmd("swayosd-client --output-volume +2"), { repeating = true })
bind(mainMod .. " + f12", hl.dsp.exec_cmd("swayosd-client --output-volume -2"), { repeating = true })
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +2"), { repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -2"), { repeating = true })
bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
bind("XF86AudioMicMute",     hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })
bind(mainMod .. " + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 100%"), { locked = true })
bind(mainMod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 0%"),   { locked = true })
