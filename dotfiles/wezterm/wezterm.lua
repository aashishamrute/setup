-- ~/.wezterm.lua
-- A WezTerm config tuned to feel like Warp: dark modern palette, soft padding,
-- a clean tab bar, and a subtle cursor. Place this file at ~/.wezterm.lua.
--
-- NOTE: WezTerm cannot reproduce Warp's "blocks" (grouping each command with its
-- output) or Warp's code-editor input line -- those are Warp-app features, not
-- terminal-emulator features. This gets the look and much of the feel close.

local wezterm = require("wezterm")
local config = wezterm.config_builder()

--------------------------------------------------------------------------------
-- FONT  <<<<<<<<<<<<  DROP YOUR FONT NAME HERE  >>>>>>>>>>>>
--------------------------------------------------------------------------------
-- Replace "YOUR FONT NAME" with the exact family name of the font you have,
-- e.g. "JetBrains Mono", "Hack Nerd Font", "MesloLGS NF", "Fira Code".
-- You can keep the fallback list so glyphs/icons still render if a char is missing.
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font Mono",          -- <-- put your installed font here
  "JetBrains Mono",          -- fallbacks (safe to leave)
  "Menlo",
})
config.font_size = 16.0
config.line_height = 1.2          -- Warp uses airy line spacing
config.cell_width = 1.0
config.harfbuzz_features = { "calt=1", "liga=1", "clig=1" } -- ligatures on

--------------------------------------------------------------------------------
-- COLOR SCHEME  (Warp "Dark"-inspired palette)
--------------------------------------------------------------------------------
config.colors = {
  foreground    = "#D5D8DE",
  background    = "#1E2028",       -- Warp dark background
  cursor_bg     = "#A48CF2",       -- Warp purple accent
  cursor_fg     = "#1E2028",
  cursor_border = "#A48CF2",
  selection_bg  = "#3A3D4D",
  selection_fg  = "#FFFFFF",

  ansi = {
    "#2A2C36", -- black
    "#F06C6C", -- red
    "#7FD88F", -- green
    "#E9C880", -- yellow
    "#7AA2F7", -- blue
    "#A48CF2", -- magenta / accent
    "#66C7D9", -- cyan
    "#C7CAD1", -- white
  },
  brights = {
    "#4A4D5C", -- bright black
    "#FF8080", -- bright red
    "#9BE8A8", -- bright green
    "#F4D89A", -- bright yellow
    "#9CB8FF", -- bright blue
    "#BFAAFF", -- bright magenta
    "#82DAE9", -- bright cyan
    "#F2F4F8", -- bright white
  },

  tab_bar = {
    background = "#17181F",
    active_tab = {
      bg_color = "#1E2028",
      fg_color = "#D5D8DE",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#17181F",
      fg_color = "#6B6F7E",
    },
    inactive_tab_hover = {
      bg_color = "#22242E",
      fg_color = "#D5D8DE",
    },
    new_tab = {
      bg_color = "#17181F",
      fg_color = "#6B6F7E",
    },
    new_tab_hover = {
      bg_color = "#22242E",
      fg_color = "#D5D8DE",
    },
  },
}

--------------------------------------------------------------------------------
-- WINDOW  (clean, roomy, modern like Warp)
--------------------------------------------------------------------------------
config.window_background_opacity = 1.0     -- set to 0.92 if you want slight transparency
config.macos_window_background_blur = 20    -- only matters if opacity < 1.0
config.window_decorations = "RESIZE"        -- keep native rounded corners, hide title clutter
config.window_padding = {
  left = 16,
  right = 16,
  top = 14,
  bottom = 12,
}
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.initial_cols = 120
config.initial_rows = 32

--------------------------------------------------------------------------------
-- TAB BAR  (slim, Warp-like)
--------------------------------------------------------------------------------
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true  -- Warp shows tabs only when >1
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 28

--------------------------------------------------------------------------------
-- CURSOR  (subtle bar-blink, like Warp's editor input)
--------------------------------------------------------------------------------
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 550
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"

--------------------------------------------------------------------------------
-- SCROLLBACK / MISC
--------------------------------------------------------------------------------
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.front_end = "WebGpu"                 -- GPU acceleration (Warp-like snappiness)
config.max_fps = 120

--------------------------------------------------------------------------------
-- KEYBINDINGS  (a few Warp-ish conveniences)
--------------------------------------------------------------------------------
local act = wezterm.action
config.keys = {
  -- Command palette (Warp: Cmd-P) -- searchable list of every action
  { key = "p", mods = "CMD",       action = act.ActivateCommandPalette },
  -- Quick select: highlight URLs/paths/hashes on screen, jump with a keypress
  { key = "Space", mods = "CMD|SHIFT", action = act.QuickSelect },
  -- Copy mode: keyboard-driven scroll/select/copy (vim-style navigation)
  { key = "x", mods = "CMD|SHIFT", action = act.ActivateCopyMode },
  -- Search scrollback (Cmd-F)
  { key = "f", mods = "CMD",       action = act.Search({ CaseInSensitiveString = "" }) },
  -- Split panes (Warp: Cmd-D / Cmd-Shift-D)
  { key = "d", mods = "CMD",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  -- Close pane (Cmd-W)
  { key = "w", mods = "CMD",       action = act.CloseCurrentPane({ confirm = false }) },
  -- New tab (Cmd-T) / next-prev tab (Cmd-Shift-[ ])
  { key = "t", mods = "CMD",       action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[", mods = "CMD|SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "CMD|SHIFT", action = act.ActivateTabRelative(1) },
  -- Move between panes with Cmd-Option-arrows
  { key = "LeftArrow",  mods = "CMD|ALT", action = act.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CMD|ALT", action = act.ActivatePaneDirection("Right") },
  { key = "UpArrow",    mods = "CMD|ALT", action = act.ActivatePaneDirection("Up") },
  { key = "DownArrow",  mods = "CMD|ALT", action = act.ActivatePaneDirection("Down") },
  -- Clear scrollback (Cmd-K), like most macOS terminals
  { key = "k", mods = "CMD",       action = act.ClearScrollback("ScrollbackAndViewport") },
}

--------------------------------------------------------------------------------
-- OPTIONAL: give inactive panes a slight dim, so the focused one "pops"
--------------------------------------------------------------------------------
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}

return config
