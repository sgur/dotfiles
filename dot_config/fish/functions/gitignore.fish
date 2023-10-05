function gitignore --description 'Generate a .gitignore file from gitignore.io'
    if count $argv >/dev/null
        curl -L -s https://www.gitignore.io/api/$argv
    else
        curl -L -s https://www.gitignore.io/api/list
    end
end
