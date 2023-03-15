scriptencoding utf-8
let &runtimepath = expand('~/.vim') . &runtimepath[stridx(&runtimepath, ',') : strridx(&runtimepath, ',')] . expand('~/.vim/after')
let &packpath = expand('~/.vim') . &packpath[stridx(&packpath, ',') : strridx(&packpath, ',')] . expand('~/.vim/after')
