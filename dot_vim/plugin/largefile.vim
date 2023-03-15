if !has('vim9script')
  finish
endif
vim9script
# largefile
# Version: 0.0.1
# Author: sgur
# License: MIT License

if exists('g:loaded_largefile')
  finish
endif
# g:loaded_largefile = 1

def Pre(path: string)
  if getfsize(path) > 2 * 1000 * 1000
    eventignore = &eventignore
    set eventignore=BufReadPost,FileType,Syntax
    setlocal foldmethod=manual
    setlocal noswapfile
  endif
enddef

def Post()
  if !empty(eventignore)
    &eventignore = eventignore
    eventignore = ''
  endif
enddef

augroup largefile
  autocmd!
  autocmd BufReadPre *  Pre(expand('<afile>:p'))
  autocmd BufWinEnter *  Post()
augroup END

var eventignore = ''

g:largefiles = {}


# vim:set et:
