" Vim compiler file
" Compiler:     tomlcheck
" Maintainer:   
" Last Change:  2020 1 22

if exists('current_compiler')
  finish
endif
let current_compiler = 'tomlcheck'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo&vim

CompilerSet makeprg=tomlcheck\ --file

CompilerSet errorformat=%E%f:%l:%c:,%-C%.%#\ \|%.%#,%C%m,%Z

let &cpo = s:save_cpo
unlet s:save_cpo
