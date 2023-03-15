if test -d ~/.fnm
    fish_add_path ~/.fnm
end

if type -q fnm
    fnm env --use-on-cd | source
end
