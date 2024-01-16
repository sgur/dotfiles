function secretlint --description 'run Docker container version of secretlint'
    pnpm --silent dlx @secretlint/quick-start $argv
end
