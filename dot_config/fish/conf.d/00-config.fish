for dir_path in ~/.yarn/bin ~/.cargo/bin ~/go/bin
    if test -d $dir_path
        fish_add_path -P $dir_path
    end
end
fish_add_path -P ~/bin ~/.local/bin

if status is-login
    if type -q hx
        set -gx EDITOR hx
    else if type -q vim
        set -gx EDITOR vim
    end
    if test "$TERM_PROGRAM" = 'vscode'
        set -gx EDITOR 'code -w'
    end

    if test (uname) = 'Darwin' -a "$TERM" = 'screen-256color'
        set -gx TERM xterm-256color
    end

    set -gx LANG ja_JP.UTF-8

    set -gx PIPENV_VENV_IN_PROJECT 1

    set -gx LESS --incsearch --quit-if-one-screen --raw-control-chars
end

if test -z "$SSH_TTY"
    set -gx GPG_TTY (tty)
end

if status is-interactive
    # unbind Alt-v (edit_command_buffer)
    bind --erase \ev

    # meaningful-ooo/sponge
    set sponge_purge_only_on_exit true
end

