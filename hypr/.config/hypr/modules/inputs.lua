---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,fr",
        kb_options = "grp:alt_caps_toggle",

        follow_mouse = 1,
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 30,
        natural_scroll = true,

        touchpad = {
            natural_scroll = true,
            disable_while_typing = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
