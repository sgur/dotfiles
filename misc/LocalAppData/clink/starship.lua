-- starship.lua

local config_dir = path.join(os.getenv("USERPROFILE"), ".config")
os.setenv("STARSHIP_CONFIG", path.join(config_dir, "starship_windows.toml"))

load(io.popen('starship init cmd'):read("*a"))()
