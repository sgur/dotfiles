vim9script


# Interface {{{1

# 実行パスのチェック
export def Executable(progname: string): bool
  var key = fnamemodify(progname, ':t')
  if !has_key(executables, key)
    executables[key] = executable(expand(progname, 1))
  endif
  return executables[key]
enddef

# Internal {{{1

def InitExecutable()
  executables = get(g:, 'VIMRC_EXECUTABLE', {})
enddef


# Initialization {{{1

var executables = {}
call InitExecutable()

augroup vimrc_vimrc
  autocmd!
  autocmd VimLeavePre *  g:VIMRC_EXECUTABLE = get(s:, 'executable', {})
augroup END

command! -nargs=0 EnvResetExecutable  call InitExecutable()


# 1}}}

