hl.on("hyprland.start", function()
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  -- TODO: status bar. waybar is installed, nothing launches it here.
  -- hl.exec_cmd("uwsm-app -- waybar")

  -- TODO: wallpaper. swaybg is installed, nothing sets one here.
  -- hl.exec_cmd("swaybg -i /path/to/wallpaper -m fill")

  -- TODO: notifications daemon. mako is installed, nothing launches it here.
  -- hl.exec_cmd("uwsm-app -- mako")

  -- TODO: idle/lock. hypridle + hyprlock are both installed, neither is
  -- wired up -- no auto-lock, no screen-off on idle.
  -- hl.exec_cmd("uwsm-app -- hypridle")

  -- TODO: input method. fcitx5 is installed, not started.
  -- hl.exec_cmd("fcitx5 --disable notificationitem")

  -- TODO: clipboard history. wl-clipboard is installed (one-shot copy/paste
  -- only) but there's no history daemon (cliphist etc) -- not installed.
end)
