if type -q eza
    function tree --wraps=eza
        command eza --tree $argv
    end
end
