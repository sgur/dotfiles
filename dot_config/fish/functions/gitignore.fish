function gitignore --description 'Generate a .gitignore file from gitignore.io'
    if count $argv >/dev/null
        curl -L -s https://www.gitignore.io/api/$argv
    else
        curl -L -s https://www.gitignore.io/api/list | string join ',' | string replace -a ',' ' ' | fold --spaces
    end
end
