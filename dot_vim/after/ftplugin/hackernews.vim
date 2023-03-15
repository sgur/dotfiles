scriptencoding utf-8

if &ambiwidth !=# 'single'
  let s:ul = &l:undolevels
  try
    setlocal undolevels=-1
    silent 1,3s/─/-/g
  finally
    let &l:undolevels = s:ul
    unlet s:ul
  endtry
endif

