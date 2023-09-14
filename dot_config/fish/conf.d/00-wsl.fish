#!/usr/bin/env fish

# WSL Specific

# 環境変数 $WSLENV を見るパターンでもよい
# if test -z "$WSLENV"
if test ! -f /proc/sys/fs/binfmt_misc/WSLInterop
   exit 0
end

# umask の設定を非WSL環境と同じにする
if test (umask) = "0000"
   umask 022
end

# Error: Too many open files 対策
# https://bayashi.net/diary/2020/0730
# - /etc/pam.d/common-session, /etc/pam.d/common-session-noninteractive に
#     session required pam_limits.so を追加した方がよいかも
ulimit --file-descriptor-count 2048

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

# Disable DISPLAY
if test -n "$WSL2_GUI_APPS_ENABLED"
   set -e DISPLAY
   set -e WAYLAND_DISPLAY
   set -e PULSE_SERVER
end
