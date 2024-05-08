if type -q eza
    function ls --wraps=eza --description eza
        command eza --classify --color=auto --color-scale=size --icons --no-quotes --group-directories-first $argv
    end
else if type -q exa
    function ls --wraps=exa --description exa
        set_color $fish_color_error
        echo "warning: Use eza instead of exa"
        command exa --classify --color=auto --color-scale --icons --no-quotes --group-directories-first $argv
    end
else
    if type -q sw_vers
        function ls
            command ls --color=auto -Fh $argv
        end
    else if test -f /proc/sys/fs/binfmt_misc/WSLInterop
        function ls --wraps=ls --description 'ls for WSL'
            command ls --color=auto --classify --human-readable --show-control-chars --ignore="hiberfil.sys" --ignore="pagefile.sys" --ignore="swapfile.sys" --hide="bootmgr" --hide="BOOTNXT" --ignore="\$Recycle.Bin" --ignore="NTUSER.DAT*" --ignore="ntuser.*" --hide="\$tf" $argv
        end
    else
        function ls
            command ls --color=auto --classify --human-readable --show-control-chars $argv
        end
    end
end
