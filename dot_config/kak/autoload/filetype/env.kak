# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/\.env %{
    set-option buffer filetype sh
}
