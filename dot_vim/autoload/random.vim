scriptencoding utf-8



" Interface {{{1

function! random#seed(n) abort
  call libcall(s:lib_path, "srand", a:n)
endfunction

function! random#rand() abort
  return libcallnr(s:lib_path, "rand", -1)
endfunction

" [a, b) $B$N6h4V$G%i%s%@%`$KCM$r=PNO$9$k(B
function! random#range(a, b) abort
  return a:a + random#rand() % (a:b - a:a)
endfunction

function! random#choice(seq) abort
  return a:seq[random#rand() % len(a:seq)]
endfunction


" Internal {{{1


" Initialization {{{1

if !exists('s:RAND_MAX')
  let s:RAND_MAX = 32768
  lockvar s:RAND_MAX
endif

let s:lib_path = has('win32') || has('win64') ? exepath('msvcrt.dll') : ''


" 1}}}
