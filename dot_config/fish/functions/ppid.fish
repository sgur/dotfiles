# https://github.com/fish-shell/fish-shell/issues/6203
function ppid
    command ps -o ppid= -p $fish_pid | string trim
end
