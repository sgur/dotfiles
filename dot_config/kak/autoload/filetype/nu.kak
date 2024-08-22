# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*\.(nu) %{
    set-option buffer filetype nu
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=nu %{
    require-module nu

    # hook window ModeChange pop:insert:.* -group nu-trim-indent nu-trim-indent
    # hook window InsertChar \n -group nu-insert nu-insert-on-new-line
    # hook window InsertChar \n -group nu-indent nu-indent-on-new-line
    # hook -once -always window WinSetOption filetype=.* %{ remove-hooks window nu-.+ }
}

hook -group nu-highlight global WinSetOption filetype=nu %{
    # add-highlighter window/nu ref nu
    # hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/nu }
}

provide-module nu %(

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

)
