" gavocanov/vim-js-indent seems better solution
" https://github.com/vim-jp/issues/issues/729#issuecomment-104672741
setlocal cinkeys&
setlocal cinkeys-=0#
setlocal cinkeys+=0]
setlocal suffixesadd+=.js

setlocal tabstop=2
setlocal expandtab

" // (1行コメント) の行継続をやめる
setlocal comments-=://

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . 'setlocal cinkeys< suffixesadd< tabstop< expandtab< comments<'
