# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.ssh/(config|conf\.d/.+\.conf) %{
    set-option buffer filetype sshclientconfig
}
hook global BufCreate /etc/ssh/ssh_config %{
    set-option buffer filetype sshclientconfig
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=sshclientconfig %{
    require-module sshclientconfig

    # hook window ModeCHange pop:insert:.* -group sshclientconfig-trim-indent sshclientconfig-trim-indent
    # hook window InsertChar \n -group sshclientconfig-insert sshclientconfig-insert-on-new-line
    # hook window InsertChar \n -group sshclientconfig-indent sshclientconfig-indent-on-new-line
    # hook -once -always window WinSetOption filetype=.* %{ remove-hooks window sshclientconfig-.+ }
}

hook -group sshclientconfig-highlight global WinSetOption filetype=sshclientconfig %{
    # add-highlighter window/sshclientconfig ref sshclientconfig
    # hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/sshclientconfig }
}

provide-module sshclientconfig %(

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

)
