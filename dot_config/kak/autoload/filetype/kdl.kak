# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(kdl) %{
    set-option buffer filetype kdl
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=kdl %{
    require-module kdl

    # hook window ModeChange pop:insert:.* -group kdl-trim-indent kdl-trim-indent
    # hook window InsertChar \n -group kdl-insert kdl-insert-on-new-line
    # hook window InsertChar \n -group kdl-indent kdl-indent-on-new-line
    # hook -once -always window WinSetOption filetype=.* %{ remove-hooks window kdl-.+ }
}

hook -group kdl-highlight global WinSetOption filetype=kdl %{
    # add-highlighter window/kdl ref kdl
    # hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/kdl }
}

provide-module kdl %(

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

)
