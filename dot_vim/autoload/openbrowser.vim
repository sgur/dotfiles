scriptencoding utf-8
" Wrapper for openbrowser

function! openbrowser#open(path) abort
  call openable#start(a:path)
endfunction


function! openbrowser#load() abort
endfunction

let g:openbrowser_open_filepath_in_vim = 0
