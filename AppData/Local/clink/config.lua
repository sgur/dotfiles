--config.lua

local scoop_dir = path.join(os.getenv("USERPROFILE"), "scoop")
local scoop_git_dir = path.join(path.join(path.join(scoop_dir, "apps"), "git"), "current")

if os.isdir(scoop_git_dir) then
  local bin_dir = path.join(path.join(scoop_git_dir, "usr"), "bin")
  os.setenv("PATH", bin_dir .. ";" .. os.getenv("PATH"))
end

local local_dir = path.join(os.getenv("USERPROFILE"), ".local")
local local_bin_dir = path.join(local_dir, "bin")

if os.isdir(local_bin_dir) then
  os.setenv("PATH", local_bin_dir .. ";" .. os.getenv("PATH") )
end
