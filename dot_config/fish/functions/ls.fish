if type -q exa
    function ls --wraps=ls --description 'exa'
        command exa --color=auto --classify --icons $argv
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
