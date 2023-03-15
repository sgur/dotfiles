scriptencoding utf-8



" Internal {{{1

" Interface {{{1

function! vimrc#operator#define(mode, title, function) abort
  let map = printf("\<Plug>(operator-%s)", a:title)
  if !hasmapto(map, a:mode)
    call operator#user#define(a:title, a:function)
  endif
  return map
endfunction

function! vimrc#operator#define_excmd(mode, title, command) abort
  let map = printf("\<Plug>(operator-%s)", a:title)
  if !hasmapto(map, a:mode)
    call operator#user#define_ex_command(a:title, a:command)
  endif
  return map
endfunction

function! vimrc#operator#packadd(mode, title, plugin) abort
  let map = printf("\<Plug>(operator-%s)", a:title)
  if !hasmapto(map, a:mode)
    execute 'packadd' a:plugin
  endif
  return map
endfunction

function! vimrc#operator#zf(motion_wiseness) abort
  if &l:foldmethod is# 'marker'
    call map(["'[", "']"], {k, v -> line(v)})
          \ ->map({k,v -> setline(v, getline(v) . ' ')})
  endif
  '[,']fold
endfunction

function! vimrc#operator#eval(motion_wiseness) abort
  let term = a:motion_wiseness isnot# 'line' ? getline("'[")[col("'[")-1: col("']")-1] : getline("'[")
  try
    let result = eval(term)
    let msg = prettyprint#prettyprint(result)
  catch /^Vim\%((\a\+)\)\=:E117/
    let msg = string(result)
  catch /^Vim\%((\a\+)\)\=:E/
    echomsg v:exception
    return
  endtry
  if has('textprop')
    call popup_atcursor(split(msg, "\n"), #{
          \   highlight: 'Search',
          \   padding: [0, 1, 0, 1],
          \   title: term
          \ })
  else
    execute 'echo' msg
  endif
endfunction

function! vimrc#operator#excmd(motion_wiseness) abort
  normal! '[V']
  redraw
  execute "'[,']" input('excmd? ', '', 'command')
  execute 'normal!' "\<ESC>"
endfunction


" Initialization {{{1


" 1}}}
