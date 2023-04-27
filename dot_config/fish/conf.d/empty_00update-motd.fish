#!/usr/bin/env fish

if not test -x /usr/bin/lsb_release ;or lsb_release --id | grep -v "Ubuntu" > /dev/null
   exit 0
end

# /etc/profile.d/update-motd.sh

set -l stamp $HOME/.motd_shown

function eval_gettext
    if type -q gettext
        echo (env TEXTDOMAIN=update-motd TEXTDOMAINDIR=/usr/share/locale gettext "$argv[1]")
    else
        echo "$argv[1]"
    end
end

# Only display this information in interactive shells
if status is-interactive
    # Also, don't display if .hushlogin exists or MOTD was shown recently
    if test ! -e "$HOME/.hushlogin" -a -z "$MOTD_SHOWN"; \
        and not find $stamp -newermt 'today 0:00' 2> /dev/null | grep -q -m 1 '.'
        set -l SHOW ""
        if test (id -u) -ne 0
            set SHOW --show-only
        end
        update-motd $SHOW
        echo ""
        eval_gettext "This message is shown once a day. To disable it please create the"
        echo -n "$HOME/.hushlogin "
        eval_gettext "file."
        touch $stamp
        set -gx MOTD_SHOWN update-motd
    end
end

functions -e eval_gettext
