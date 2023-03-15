# Homebrew
# https://brew.sh/
#
# Linuxbrew
# https://docs.brew.sh/Homebrew-on-Linux
#
#   prerequisite:
#   sudo apt-get install build-essential procps curl file git
#

# Homebrew
if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv | source
end

# Linuxbrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if not type -q brew
    exit 0
end

if not contains $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
    set -gx fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
end

set -gx HOMEBREW_CURLRC 1

if test -d $HOMEBREW_PREFIX/opt/node@16
    fish_add_path -g $HOMEBREW_PREFIX/opt/node@16/bin
    set -gx LDFLAGS "-L$HOMEBREW_PREFIX/opt/node@16/lib" $LDFLAGS
    set -gx CPPFLAGS "-I$HOMEBREW_PREFIX/opt/node@16/include" $CPPFLAGS
end

if test -d $HOMEBREW_PREFIX/opt/openjdk@17
    fish_add_path -g $HOMEBREW_PREFIX/opt/openjdk@17/bin
end

if test -d $HOMEBREW_PREFIX/opt/dotnet@6
    set -gx DOTNET_ROOT $HOMEBREW_PREFIX/opt/dotnet@6/libexec
    fish_add_path -g $HOMEBREW_PREFIX/opt/dotnet@6/bin
end

if test -d $HOMEBREW_PREFIX/opt/fzf
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish
end
