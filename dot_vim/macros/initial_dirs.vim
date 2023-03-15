scriptencoding utf-8

function! s:initialize_dirs(base, dirs)
  let basedir = fnamemodify(a:base, ':p')
  for dir in a:dirs
    let path = expand(printf('%s/%s', basedir, dir))
    if isdirectory(path)
      continue
    endif
    call mkdir(path, 'p')
    echohl WarningMsg | echomsg 'Create' dir | echohl NONE
  endfor
endfunction
call s:initialize_dirs('~/.cache/vim', ['backup', 'swap', 'undo', 'view'])
