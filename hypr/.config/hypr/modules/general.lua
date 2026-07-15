-----------------
---- GENERAL ----
-----------------

hl.config({
    general = {
        layout = "dwindle",

		snap = {
			enabled = true,
		},
    },

    ecosystem = {
    	no_donation_nag = true,
    },

	cursor = {
		inactive_timeout = 5,
	},

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
        middle_click_paste = false,
    },
    
    dwindle = {
		force_split = 2,
        preserve_split = true,
    },

    xwayland = {
   		force_zero_scaling = true,
   	},
})
