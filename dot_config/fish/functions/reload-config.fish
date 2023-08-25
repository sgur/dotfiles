function reload-config
    for file in ~/.config/fish/config.fish ~/.config/fish/conf.d/*.fish
        test -f $file -a -r $file
        source $file
    end
end
