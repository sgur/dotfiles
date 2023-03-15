if !has('vim9script')
  finish
endif
vim9script
# translate

if exists('g:loaded_translate')
  finish
endif
g:loaded_translate = 1


import autoload "translate.vim"

command! -bang -range -nargs=? Translate translate.Translate('<bang>', <line1>, <line2>, <f-args>)

nnoremap <silent> <Plug>(Translate) <Cmd>Translate<CR>
vnoremap <silent> <Plug>(VTranslate) :Translate<CR>

# vim:set et:
