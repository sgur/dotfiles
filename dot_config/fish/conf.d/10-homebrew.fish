# Homebrew
# https://brew.sh/
#
# Linuxbrew
# https://docs.brew.sh/Homebrew-on-Linux
#
#   prerequisite:
#   sudo apt-get install build-essential procps curl file git
#

if status is-login
    # Homebrew
    if test -x /usr/local/bin/brew
        /usr/local/bin/brew shellenv | source
    end

    # Linuxbrew
    if test -x /home/linuxbrew/.linuxbrew/bin/brew
        /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
    end
end

if not type -q brew
    exit 0
end

if status is-login
    if not contains $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
        set -gx fish_complete_path $HOMEBREW_PREFIX/share/fish/vendor_completions.d $fish_complete_path
    end

    set -gx HOMEBREW_CURLRC 1

    if test -d $HOMEBREW_PREFIX/opt/openssl@1.1
        set -l prefix (brew --prefix openssl@1.1)
        fish_add_path -g $prefix/bin
        set -gx LDFLAGS "-L$prefix/lib" $LDFLAGS
        set -gx CPPFLAGS "-I$prefix/include" $CPPFLAGS
    end

    if test -d $HOMEBREW_PREFIX/opt/openssl@3
        set -l prefix (brew --prefix openssl@3)
        fish_add_path -g $prefix/bin
        set -gx LDFLAGS "-L$prefix/lib" $LDFLAGS
        set -gx CPPFLAGS "-I$prefix/include" $CPPFLAGS
    end

    if test -d $HOMEBREW_PREFIX/opt/node@18
        set -l prefix (brew --prefix node@18)
        fish_add_path -g $prefix/bin
        set -gx LDFLAGS "-L$prefix/lib" $LDFLAGS
        set -gx CPPFLAGS "-I$prefix/include" $CPPFLAGS
    else if test -d $HOMEBREW_PREFIX/opt/node@16
        set -l prefix (brew --prefix node@16)
        fish_add_path -g $prefix/bin
        set -gx LDFLAGS "-L$prefix/lib" $LDFLAGS
        set -gx CPPFLAGS "-I$prefix/include" $CPPFLAGS
    end

    if test -d $HOMEBREW_PREFIX/opt/openjdk@17
        set -l prefix (brew --prefix openjdk@17)
        fish_add_path -g $prefix/bin
    end

    if test -d $HOMEBREW_PREFIX/opt/dotnet@6
        set -l prefix (brew --prefix dotnet@6)
        fish_add_path -g $prefix/bin
        set -gx DOTNET_ROOT $prefix/libexec
    end

    if test -d $HOMEBREW_PREFIX/opt/ruby@3.1
        set -l prefix (brew --prefix ruby@3.1)
        fish_add_path -g $prefix/bin
        set -gx LDFLAGS "-L$prefix/lib" $LDFLAGS
        set -gx CPPFLAGS "-I$prefix/include" $CPPFLAGS
    end
end

if test -d $HOMEBREW_PREFIX/opt/fzf
    source $HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.fish
end
