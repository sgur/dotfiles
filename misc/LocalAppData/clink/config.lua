--config.lua

local config_dir = path.join(os.getenv("USERPROFILE"), ".config")

local scoop_dir = path.join(os.getenv("USERPROFILE"), "scoop")
local scoop_git_dir = path.join(path.join(path.join(scoop_dir, "apps"), "git"), "current")

if os.isdir(scoop_git_dir) then
  local bin_dir = path.join(path.join(scoop_git_dir, "usr"), "bin")
  os.setenv("PATH", os.getenv("PATH") .. ";" .. bin_dir)
end
