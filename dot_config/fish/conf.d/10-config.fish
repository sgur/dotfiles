for dir_path in ~/.yarn/bin ~/.cargo/bin ~/go/bin
    if test -d $dir_path
        fish_add_path -P $dir_path
    end
end
fish_add_path -P ~/bin ~/.local/bin

if status is-login
    set -gx EDITOR vim
    # version が 23.05 より新しければ EDITOR に hx を設定する
    if type -q hx
        set -l hx_version (hx --version | string split ' ')
        if test $hx_version[2] -ge 23.05 ;and not string match '* (7f5940be)' $hx_version[3]
            set -gx EDITOR hx
        end
    end
    # git commit では copilot を使いたいので vim を利用する
    set -gx GIT_EDITOR vim
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

if type -q gpg
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

if status is-interactive
    # unbind Alt-v (edit_command_buffer)
    bind --erase \ev

    # meaningful-ooo/sponge
    set sponge_purge_only_on_exit true
end

