function rm --wraps=rm
    if test (uname) = 'Darwin'
        command rm -i $argv
    else
        command rm --interactive=once $argv
    end
end

# vim:ts=4 sw=4 et
