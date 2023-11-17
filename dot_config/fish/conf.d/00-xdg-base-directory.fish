status is-login || exit

# https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html
set -gx XDG_DATA_HOME $HOME/.local/share
set -gx XDG_CONFIG_HOME $HOME/.config
if test -z "$XDG_DATA_DIRS"
    set -gx XDG_DATA_DIRS /usr/local/share:/usr/share
end
set -gx XDG_CONFIG_DIRS /etc/xdg
set -gx XDG_CACHE_HOME $HOME/.cache

# Expand $PATH to include the directory where snappy applications go.
fish_add_path --append --path /snap/bin

# Desktop files (used by desktop environments within both X11 and Wayland) are looked for in XDG_DATA_DIRS; make sure it includes
# the relevant directory for snappy applications' desktop files.
set -l snap_xdg_path "/var/lib/snapd/desktop"
if test -d $snap_xdg_path ;and not string match --quiet "*$snap_xdg_path" $XDG_DATA_DIRS
    set -gx XDG_DATA_DIRS $XDG_DATA_DIRS:$snap_xdg_path
end

# https://dev.to/bowmanjd/using-podman-on-windows-subsystem-for-linux-wsl-58ji
if test -z "$XDG_RUNTIME_DIR"
    set -gx XDG_RUNTIME_DIR /run/user/$UID
    if test ! -d "$XDG_RUNTIME_DIR"a
        set -gx XDG_RUNTIME_DIR /tmp/$USER-runtime
        if test ! -d "$XDG_RUNTIME_DIR"
            mkdir -m 0700 "$XDG_RUNTIME_DIR"
        end
    end
end
