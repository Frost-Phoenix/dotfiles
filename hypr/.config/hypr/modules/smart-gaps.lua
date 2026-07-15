-- "Smart gaps" / "No gaps when only"

hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })

local window_rules = {
    hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 }),
    hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 }),
    hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, border_size = 0 }),
    hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" }, rounding = 0 }),
}

local smart_gaps_enabled = true

hl.bind("SUPER + G", function()
    smart_gaps_enabled = not smart_gaps_enabled

    for _, rule in ipairs(window_rules) do
        rule:set_enabled(smart_gaps_enabled)
    end

	if smart_gaps_enabled then
		hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
		hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 0, gaps_in = 0 })
	else
		hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 12, gaps_in = 6 })
		hl.workspace_rule({ workspace = "f[1]s[false]", gaps_out = 12, gaps_in = 6 })
	end
end)
