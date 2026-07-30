--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local function float_centered_rule(opts)
    opts.float = true
    opts.size = opts.size or { 1200, 800 }
    opts.center = true

   	return hl.window_rule(opts)
end

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "calculator-float",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
})

hl.window_rule({
    name  = "share-picker-float",
    match = { class = "^(hyprland-share-picker)$" },
    float = true,
})

float_centered_rule({
    name  = "pavucontrol-float",
    match = { class = "(.*pavucontrol.*)" },
})

float_centered_rule({
    name  = "fileroller-float",
    match = { class = "^(org.gnome.FileRoller)$" },
})

float_centered_rule({
    name       = "float-by-title",
    match      = { title = ".*(Open (File|Folder|Document)|Choose Files|Save).*" },
    dim_around = true,
})

float_centered_rule({
    name       = "float-xdg-portal",
    match      = { class = "xdg-desktop-portal-gtk" },
    dim_around = true,
})

float_centered_rule({
    name  = "blueman-manager-float",
    match = { class = "(blueman-manager)" },
})

float_centered_rule({
    name  = "media-float",
    match = { class = "(imv|mpv)" },
})

float_centered_rule({
    name  = "piper-float",
    match = { class = "piper" },
})

hl.window_rule({
  name = "picture-in-picture",
  float = true,
  move = { 1920 - 650 - 2, 1200 - 32 - 366 },
  size = { 650, 366 },
  pin = true,
  match = { title = "^(Picture-in-Picture)$" }
})

hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, dim_around = true })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, dim_around = true })

hl.window_rule({ match = { class = "^(app.zen_browser.zen)$" }, workspace = 1 })
hl.window_rule({ match = { class = "(.*codium.*)" }, workspace = 3 })
hl.window_rule({ match = { class = "^(Aseprite)$" }, workspace = 4 })
hl.window_rule({ match = { class = "^(audacious)$" }, workspace = 5 })
hl.window_rule({ match = { class = "(.*NewsFlash.*)" }, workspace = 6 })
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, workspace = 8 })
hl.window_rule({ match = { class = "^(io.missioncenter.MissionCenter)$" }, workspace = 9 })
hl.window_rule({ match = { class = "(.*vesktop.*)" }, workspace = 10 })

----------------
---- LAYERS ----
----------------

for _, namespace in ipairs({ "swaync-control-center", "rofi" }) do
    hl.layer_rule({
        name = namespace .. "-dim",
        match = { namespace = namespace },
        dim_around = true,
    })
end
