scriptencoding utf-8

" jsx の Flow 用 syntax
if expand('%:e') is? 'jsx'
  runtime! syntax/javascriptreact.vim
endif

