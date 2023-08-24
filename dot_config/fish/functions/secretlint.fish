function secretlint --description 'run Docker container version of secretlint'
    docker run -v (pwd):(pwd) -w (pwd) --rm -it secretlint/secretlint secretlint $argv
end
