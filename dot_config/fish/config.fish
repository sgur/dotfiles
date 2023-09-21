if type -q gpg
    set -gx GPG_TTY (tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
end

# vscode の integrated terminal からは vscode のエディターを開く
if test "$TERM_PROGRAM" = vscode
    set -gx EDITOR 'code -w'
end

# 共通の設定はログインシェルでのみ行う
status is-login || exit

for dir_path in ~/.yarn/bin ~/.cargo/bin ~/go/bin ~/.dotnet/tools
    if test -d $dir_path
        fish_add_path $dir_path
    end
end
fish_add_path ~/bin ~/.local/bin

# meaningful-ooo/sponge
set sponge_purge_only_on_exit true

# git commit では copilot を使いたいので vim を利用する
set -gx GIT_EDITOR vim

if test (uname) = Darwin -a "$TERM" = screen-256color
    set -gx TERM xterm-256color
end

set -gx LANG ja_JP.UTF-8

set -gx PIPENV_VENV_IN_PROJECT 1

set -gx LESS --incsearch --quit-if-one-screen --raw-control-chars
