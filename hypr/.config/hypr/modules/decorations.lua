---------------------
---- DECORATIONS ----
---------------------

hl.config({
    general = {
        gaps_in  = 6,
        gaps_out = 12,

        border_size = 2,

        col = {
            active_border   = { colors = {"rgba(98971aee)", "rgba(cc241dee)"}, angle = 45 },
            inactive_border = "rgba(3c3836aa)",
        },
    },

    decoration = {
        rounding = 0,

        blur = {
            enabled   = true,

            size      = 4,
            passes    = 2,
    
            contrast = 1.4,
            noise = 0,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
    },
})
