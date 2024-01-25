complete --command gitignore --exclusive --arguments (curl -sL https://www.gitignore.io/api/list | string join ',' | string replace -a ',' ' ')
