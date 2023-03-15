" syntax で折り畳み
setlocal foldmethod=syntax nrformats+=alpha path+=include/,../include/

" 自動的にDoxygenのシンタックスを有効にする
let b:load_doxygen_syntax = 1

" // (1行コメント) の行継続をやめる
setlocal comments-=://

let b:undo_ftplugin = (exists('b:undo_ftplugin')? b:undo_ftplugin . '|': '')
      \ . "setlocal foldmethod< path< nrformats< comments< | unlet! b:load_doxygen_syntax"
