" Vim compiler file
" Compiler:     cfn-lint
" Maintainer:   
" Last Change:  2019 10 23

if exists('current_compiler')
  finish
endif
let current_compiler = 'cfn-lint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo&vim

CompilerSet makeprg=cfn-lint\ -f\ parseable

" CompilerSet errorformat=%EE%n\ %m,%Z%f:%l:%c,%-G
CompilerSet errorformat=%f:%l:%c:%*[^E]E%n:%m

let &cpo = s:save_cpo
unlet s:save_cpo
