local wezterm = require 'wezterm';

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local function basename(s)
  return s:gsub("(.*[/\\])(.*)", "%2"):match("[^.]*")
end

local function path_join(a, b)
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    return a .. "\\" .. b
  else
    return a .. "/" .. b
  end
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local process_name = basename(pane.foreground_process_name)
  if process_name == "wslhost" then
    return tab.tab_index .. ": " .. "wsl"
  end
  return tab.tab_index .. ": " .. process_name -- .. " " .. pane.pane_id
end)

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.audible_bell = "Disabled"
config.check_for_updates = false
-- https://github.com/wez/wezterm/tree/main/assets/colors
-- 2022-04-05: Tomorrow Night
-- 2022-04-14: Belafonte Night
-- 2022-04-21: Afterglow
-- 2022-04-25: Rapture
-- 2023-08-23: SynthWave (Gogh)
config.color_scheme = "Catppuccin Mocha"
config.hyperlink_rules = {
  -- default
  {
    regex = "\\b\\w+://(?:[\\w.-]+)\\.[a-z]{2,15}\\S*\\b",
    format = "$0",
  },
  -- localhost:8080 or 127.0.0.1:8080
  {
    regex = "\\bhttp://(?:localhost|\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3})(?::\\d+)?\\b",
    format = "$0",
  }
}
config.initial_cols = 136
config.initial_rows = 40
config.keys = {
  {key="p", mods="CTRL|SHIFT", action="ShowLauncher"},
  {key="F9", mods="ALT", action="ShowTabNavigator"},
  {key="F4", mods="CTRL", action=wezterm.action{CloseCurrentPane={confirm=true}}},
  {key="o", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Next"}},
  {key="LeftArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
  -- {key="DownArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
  {key="UpArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
  {key="RightArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
}
config.text_background_opacity = 1.0
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}
config.window_background_opacity = 0.92

-- x86_64-pc-windows-msvc - Windows
-- x86_64-apple-darwin - macOS
-- x86_64-unknown-linux-gnu - Linux
if wezterm.target_triple == "x86_64-pc-windows-msvc" then

  local success, stdout, stderr = wezterm.run_child_process { 'cmd.exe', 'ver' }
  local major, minor, build, rev = stdout:match("Version ([0-9]+)%.([0-9]+)%.([0-9]+)%.([0-9]+)")
  local is_windows_11 = tonumber(build) >= 22000
  local is_support_mica = tonumber(build) >= 22621

  config.default_prog = { "C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe" }
  config.font = wezterm.font("PlemolJP Console NF")
  config.font_size = 13.0
  config.freetype_load_target = "Light"
  config.freetype_load_flags = "NO_HINTING|NO_BITMAP|MONOCHROME"
  config.line_height = 1.0
  config.unicode_version = 14
  config.launch_menu = {
    {
      label = "Command Promt with clink",
      args = { "cmd.exe", "/k", "clink", "inject" }
    },
    {
      label = "PowerShell Core",
      args = { "pwsh.exe" }
    },
    {
      label = "Ubuntu",
      args = { "wsl.exe", "~" }
    },
    {
      label = "PowerShell Core Preview",
      args = { "C:\\Program Files\\PowerShell\\7-preview\\pwsh.exe" }
    },
    {
      label = "Developer PowerShell for VS2019",
      args = { "pwsh.exe", "-NoExit", "-NoLogo", "-Command", "Enter-VsDevShell2019" }
    }
  }
  local appearance = get_appearance()
  config.color_scheme = "Catppuccin Mocha" -- scheme_for_appearance(appearance)
  if appearance == "Dark" and is_support_mica then
    config.window_background_opacity = 0.00
    config.win32_system_backdrop = "Mica" -- "Tabbed"
  else
    config.win32_acrylic_accent_color = "#FFFFFF"
    config.window_background_opacity = 0.80
    config.win32_system_backdrop = "Acrylic"
  end
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
end
if wezterm.target_triple == "aarch64-apple-darwin" then
  config.font = wezterm.font("PlemolJP Console NF")
  config.font_size = 16
end
if wezterm.target_triple == "x86_64-apple-darwin" then
  config.font = wezterm.font("PlemolJP Console NF")
  config.font_size = 16
end

return config
