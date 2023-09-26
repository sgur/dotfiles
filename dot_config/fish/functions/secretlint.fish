function secretlint --description 'run Docker container version of secretlint'
    if type -q npx
        npx --yes @secretlint/quick-start $argv
    else
        docker run -v (pwd):(pwd) -w (pwd) --rm -it secretlint/secretlint secretlint $argv
    end
end
