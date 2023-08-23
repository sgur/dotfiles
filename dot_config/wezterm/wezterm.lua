local wezterm = require 'wezterm';

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

local config = {
  audible_bell = "Disabled",
  check_for_updates = false,
  -- https://github.com/wez/wezterm/tree/main/assets/colors
  -- 2022-04-05: Tomorrow Night
  -- 2022-04-14: Belafonte Night
  -- 2022-04-21: Afterglow
  -- 2022-04-25: Rapture
  -- 2023-08-23: SynthWave (Gogh)
  color_scheme = "Catppuccin Mocha",
  hyperlink_rules = {
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
  },
  initial_cols = 136,
  initial_rows = 40,
  keys = {
    {key="p", mods="CTRL|SHIFT", action="ShowLauncher"},
    {key="F9", mods="ALT", action="ShowTabNavigator"},
    {key="F4", mods="CTRL", action=wezterm.action{CloseCurrentPane={confirm=true}}},
    {key="o", mods="ALT|SHIFT", action=wezterm.action{ActivatePaneDirection="Next"}},
    {key="LeftArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 1}}},
    {key="DownArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 1}}},
    {key="UpArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 1}}},
    {key="RightArrow", mods="ALT|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 1}}},
  },
  text_background_opacity = 1.0,
  visual_bell = {
    fade_in_function = "EaseIn",
    fade_in_duration_ms = 150,
    fade_out_function = "EaseOut",
    fade_out_duration_ms = 150,
  },
  window_background_opacity = 0.92,
}

-- x86_64-pc-windows-msvc - Windows
-- x86_64-apple-darwin - macOS
-- x86_64-unknown-linux-gnu - Linux
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  local pwsh_path = "pwsh.exe"
  config.default_prog = { pwsh_path }
  config.font = wezterm.font("UDEV Gothic NFLG")
  config.font_size = 12
  config.exit_behavior = 'Hold'
  config.launch_menu = {
    {
      label = "Command Promt with clink",
      args = { "cmd.exe", "/k", "clink", "inject" }
    },
    {
      label = "PowerShell Core",
      args = { pwsh_path }
    },
    {
      label = "zellij (WSL)",
      args = { "wsl.exe", "~", "--exec", "sh", "-l", "-c", "zellij attach 2> /dev/null || zellij" }
    },
    {
      label = "Developer PowerShell for VS2019",
      args = { pwsh_path, "-NoExit", "-NoLogo", "-Command", "Enter-VsDevShell2019" }
    },
    {
      label = "cntlm log (Docker)",
      args = { "wsl.exe", "-u", "root", "--", "docker", "logs", "--follow", "--tail", "30", "cntlm" }
    },
    {
      label = "scoop update",
      args = { "powershell.exe", "-NoProfile", "-NoExit", "-Command", "scoop", "update", ";", "scoop", "status", ";", "pause", ";", "scoop", "update", "*", ";", "scoop", "cleanup", "--all" }
    },
    {
      label = "apt update & upgrade",
      args = { "wsl.exe", "~", "-u", "root", "--exec", "/usr/libexec/nslogin", "sh", "-c", "apt update && apt upgrade -y && read -p 'Hit enter...' nop" }
    },
    {
      label = "Ubuntu",
      args = { "wsl.exe", "~" }
    }
  }
end
if wezterm.target_triple == "x86_64-apple-darwin" then
  config.font = wezterm.font("UDEV Gothic NFLG")
  config.font_size = 16
end

return config
