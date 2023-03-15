scriptencoding utf-8
" Flow 用の ftplugin が用意されていない場合の応急処置

if exists('b:did_ftplugin')
  finish
endif

if expand('%:e') is? 'jsx'
  runtime! ftplugin/javascriptreact.vim
else
  runtime! ftplugin/javascript.vim
endif

let b:did_ftplugin = 1
