---@diagnostic disable: undefined-global, undefined-field
if (clink.version_encoded or 0) < 10020030 then
   error("fnm requires a newer version of Clink; please upgrade to Clink v1.2.30 or later.")
end

local fnm_prompt = clink.promptfilter(4)
function fnm_prompt:filter(prompt)
  local dir = os.getcwd()
  if os.isfile(path.join(dir, '.node-version')) then
    os.execute("fnm use --silent-if-unchanged")
  end
  return prompt
end

local function fnm_init()
  local output = io.popen("fnm env"):read("*a")
  local cmds = string.explode(output, "\n")
  for i = 1, #cmds do
    local cmd = string.sub(cmds[i], 5)
    local pair = string.explode(cmd, "=")
    os.setenv(pair[1], pair[2])
  end
end
local function fnm_init_error(err)
  print("fnm env failed:", err)
end
xpcall(fnm_init, fnm_init_error)
