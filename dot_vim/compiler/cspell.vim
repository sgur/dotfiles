" Vim compiler file
" Compiler:     cspell
" Maintainer:   sgur
" Last Change:  2020 11 04

if exists('current_compiler')
  finish
endif
let current_compiler = 'cspell'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo&vim

CompilerSet makeprg=npx\ cspell\ --no-color\ --no-issues\ --no-summary

CompilerSet errorformat=%I%f:%l:%c\ -\ %m,%Z

let &cpo = s:save_cpo
unlet s:save_cpo
