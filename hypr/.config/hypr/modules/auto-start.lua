-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function () 
  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("uwsm-app -- flatpak run app.zen_browser.zen", { workspace = "1 silent" })
  hl.exec_cmd("uwsm-app -- flatpak run io.gitlab.news_flash.NewsFlash", { workspace = "6 silent" })
end)
