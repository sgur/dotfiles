if !has('vim9script')
  finish
endif
vim9script
# autocmds
# Version: 0.0.1

if exists('g:loaded_autocmds')
  finish
endif
g:loaded_autocmds = 1

import autoload 'autocmds.vim'

def Complete(arglead: string, cmdline: string, cursorpos: number): list<string>
  return autocmds.Complete(arglead, cmdline, cursorpos)
enddef

command! -narg=* -complete=customlist,Complete AutoCmdsLog  autocmds.Apply([<f-args>])


# vim:set et:
