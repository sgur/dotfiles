function fish_greeting
    echo -n '🐟, the friendly interactive shell'
    if status is-login
        echo -n ", --login"
    end
    if status is-interactive
        echo -n ", --interactive"
    end
    echo ""
end
