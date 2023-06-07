if type -q pyenv
    pyenv init - | source
end

if test -x ~/.pyenv/bin/pyenv
    set -gx PYENV_ROOT $HOME/.pyenv
    fish_add_path -g $PYENV_ROOT/bin
    pyenv init - | source
end
