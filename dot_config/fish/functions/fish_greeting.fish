function fish_greeting
    echo -n 'Welcome to 🐟, the friendly'
    if status is-login
        echo -n ", login"
    end
    if status is-interactive
        echo -n ", interactive"
    end
    echo -n " shell"
    if test -z "$fish_prompt_type" && type -q tide
        echo -n ' with 🌊 Tide'
    end
    echo ""
end
