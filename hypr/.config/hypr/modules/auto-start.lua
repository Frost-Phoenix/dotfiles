-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function () 
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
end)
