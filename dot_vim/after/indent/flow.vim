scriptencoding utf-8
" Flow 用の indent が用意されていない場合の応急処置

if exists('b:did_indent')
  finish
endif

if expand('%:e') is? 'jsx'
  runtime! indent/javascriptreact.vim
else
  runtime! indent/javascript.vim
endif

let b:did_indent = 1
