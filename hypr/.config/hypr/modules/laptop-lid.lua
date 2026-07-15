--------------------
---- LAPTOP LID ----
--------------------

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprlock & systemctl suspend"))

-- hl.bind("switch:off:Lid Switch", function()
--     handle_monitor_state()
-- end)
