fish_add_path -P ~/bin ~/.local/bin ~/.cargo/bin ~/go/bin

set -gx EDITOR vim
if test "$TERM_PROGRAM" = 'vscode'
    set -gx EDITOR 'code -w'
end

if test (uname) = 'Darwin' -a "$TERM" = 'screen-256color'
    set -gx TERM xterm-256color
end

set -gx LANG ja_JP.UTF-8

# unbind Alt-v (edit_command_buffer)
bind --erase \ev

set -gx PIPENV_VENV_IN_PROJECT 1

set -gx GPG_TTY (tty)

# meaningful-ooo/sponge
set sponge_purge_only_on_exit true

set -gx LESS --incsearch --quit-if-one-screen
