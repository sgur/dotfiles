status is-login || exit

# https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx XDG_DATA_DIRS /usr/local/share/:/usr/share/
set -gx XDG_CONFIG_DIRS /etc/xdg
set -gx XDG_CACHE_HOME $HOME/.cache

# https://dev.to/bowmanjd/using-podman-on-windows-subsystem-for-linux-wsl-58ji
if test -z "$XDG_RUNTIME_DIR"
    set -gx XDG_RUNTIME_DIR /run/user/$UID
    if test ! -d "$XDG_RUNTIME_DIR"
        set -gx XDG_RUNTIME_DIR /tmp/$USER-runtime
        if test ! -d "$XDG_RUNTIME_DIR"
            mkdir -m 0700 "$XDG_RUNTIME_DIR"
        end
    end
end
