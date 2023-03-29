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

# ls for WSL
function ls --wraps=ls --description 'ls for WSL'
   command ls --color=auto --classify --human-readable --ignore="hiberfil.sys" --ignore="pagefile.sys" --ignore="swapfile.sys" --hide="bootmgr" --hide="BOOTNXT" --ignore="\$Recycle.Bin" --ignore="NTUSER.DAT*" --ignore="ntuser.*" --hide="\$tf" $argv
end

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

# pseudo open command for WSL
# https://zenn.dev/ys/books/6e3f3bc6e3cf741484df/viewer/af1079468fc71320314f#windows%E3%81%AE%E9%96%A2%E9%80%A3%E4%BB%98%E3%81%91%E3%81%A7%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E9%96%8B%E3%81%8F
function open --description 'alias open=/mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler (wslpath -w $argv)'
   if test -f $argv
      $EDITOR $argv
   else
      /mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler (wslpath -w $argv) 2> /dev/null
   end
end

set -gx BROWSER '/mnt/c/Windows/System32/rundll32.exe url.dll,FileProtocolHandler'

# Disable DISPLAY
if test -n "$WSL2_GUI_APPS_ENABLED"
   set -e DISPLAY
   set -e WAYLAND_DISPLAY
   set -e PULSE_SERVER
end

function wsl-compact-memory --description 'compact'
   # https://www.ncaq.net/2022/01/29/15/04/12/#%E3%83%A1%E3%83%A2%E3%83%AA%E9%A3%9F%E3%81%84%E9%81%8E%E3%81%8E

   # WSLなどで際限なくメモリをキャッシュなどに確保して、
   # ホスト側メモリを食い尽くした時に、
   # 再起動無しでメモリを開放するためのコマンドです。

   sync
   echo 3 > /proc/sys/vm/drop_caches
   echo 1 > /proc/sys/vm/compact_memory
end
