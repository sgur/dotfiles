function fish_greeting
    echo -n '🐟, the friendly'
    if status is-login
        echo -n ", login"
    end
    if status is-interactive
        echo -n ", interactive"
    end
    echo " shell"
end
