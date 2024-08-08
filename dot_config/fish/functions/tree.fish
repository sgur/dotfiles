if type -q eza
    function tree --wraps=eza 
        command eza --tree
    end
end
