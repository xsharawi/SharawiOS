-- Set programs that you use
local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "thunar"

hl.monitor({
  output = "DP-1",
  mode = "2560x1440@180.00",
  position = "1920x0",
  scale = 1,
  bitdepth = 10,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "1920x1080@100",
  position = "0x0",
  scale = 1,
  bitdepth = 10,
})

hl.workspace_rule({ workspace = "2", monitor = "DP-1", default = false })
hl.workspace_rule({ workspace = "3", monitor = "DP-1", default = true })

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment")
  hl.exec_cmd("wl-clip-persist --clipboard regular")
  hl.exec_cmd("xrandr --output DP-1 --primary")
  hl.exec_cmd("kdeconnect-indicator &")
  hl.exec_cmd("noctalia --daemon")
  hl.exec_cmd("awww-daemon &")
  hl.exec_cmd("keepassxc")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprctl plugin load /etc/nixos/extra/hyprselect.so")
  hl.exec_cmd(terminal)
end)

hl.config({
  dwindle = {
    preserve_split = true, -- You probably want this
  },
})

hl.workspace_rule({ workspace = "1", on_created_empty = "[silent] obsidian" })
hl.workspace_rule({ workspace = "2", on_created_empty = "[silent] " .. terminal })
hl.workspace_rule({ workspace = "3", on_created_empty = "[silent] zen-beta" })

hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()'"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT+ H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT+ L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT+ K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT+ J", hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("noctalia msg panel-open launcher"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("pamixer --toggle-mute"))
hl.bind(mainMod .. " + U", hl.dsp.workspace.move({ monitor = "+1" }))

hl.bind(
  mainMod .. " + page_down",
  hl.dsp.exec_cmd("grimblast --freeze copysave area ~/Pictures/$(date +%Y-%m-%d_%H-%m-%s).png")
)

hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("woomer --monitor DP-1"))
hl.bind("CTRL + ESCAPE", hl.dsp.exec_cmd("hyprctl switchxkblayout moergo-glove80-left-keyboard next"))

-- To switch between windows in a floating workspace:
hl.bind("SUPER + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
  hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
end)

hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 10, y = 0 }))
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -10, y = 0 }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -10 }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 10 }))

hl.bind(mainMod .. " + up", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind(mainMod .. " + down", hl.dsp.exec_cmd("pamixer -d 5"))

hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + P", hl.dsp.focus({ workspace = "e-1" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.window_rule({
  -- Fix some dragging issues with XWayland
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true,
})

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

hl.config({
  decoration = {

    -- wobble = {
    --   enabled = true,
    -- },
    blur = {
      enabled = true,
      ignore_opacity = true,
      passes = 3,
      size = 3,
    },

    shadow = { color = "rgba(1e1e2e99)" },
    active_opacity = 1,
    fullscreen_opacity = 1,
    inactive_opacity = 0.900000,
    rounding = 15,
  },
})

hl.config({
  ecosystem = { no_update_news = true },
})

hl.env("HYPRCURSOR_THEME", "Banana")
hl.env("HYPRCURSOR_SIZE", "40")
hl.env("XCURSOR_SIZE", "40")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.config({
  general = {
    allow_tearing = true,
    border_size = 2,

    col = { active_border = "rgba(1fffffff)", inactive_border = "rgba(1e45475a)" },
    gaps_in = 2,
    gaps_out = 8,
    layout = "dwindle",
  },
})

hl.config({
  input = {
    touchpad = { natural_scroll = yes },
    follow_mouse = 2,
    kb_layout = "us,ara",
    numlock_by_default = true,
    sensitivity = 0,
  },
})

hl.config({
  misc = {
    force_default_wallpaper = 0,
    middle_click_paste = false,
    animate_manual_resizes = true,
    background_color = "rgba(1e1e1e2e)",
    disable_hyprland_logo = true,
    focus_on_activate = true,
    font_family = "JetBrainsMono Nerd Font",
  },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
