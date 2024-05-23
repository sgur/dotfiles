scriptencoding utf-8

autocmd BufNewFile,BufRead *.vssettings  setfiletype xml
autocmd BufNewFile,BufRead *.exe.config  setfiletype xml
autocmd BufNewFile,BufRead *.git/TAG_EDITMSG  setfiletype gitcommit
autocmd BufNewFile,BufRead *.isl  setfiletype dosini
autocmd BufNewFile,BufRead .tmux.conf  setfiletype tmux
autocmd BufNewFile,BufRead .bowerrc  setfiletype json
autocmd BufNewFile,BufRead .csslintrc  setfiletype json
autocmd BufNewFile,BufRead .babelrc  setfiletype jsonc
autocmd BufNewFile,BufRead .Brewfile  setfiletype brewfile
autocmd BufNewFile,BufRead ~/.ssh/conf.d/*.conf setfiletype sshconfig
autocmd BufNewFile,BufRead .prototools setfiletype toml
