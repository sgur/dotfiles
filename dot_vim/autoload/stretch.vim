scriptencoding utf-8



" Interface {{{1

function! stretch#do() abort
  let current = winnr()
  let others = map(filter(map(filter(range(1, winnr('$')), 'v:val != ' . current), 'winheight(v:val)'), 'v:val >= ' . s:winminheight()), 'v:val / 2.0')
  execute 'resize' winheight(0) + float2nr(!empty(others) ? eval(join(others, '+')) : 0)
endfunction


" Internal {{{1

function! s:winminheight() abort "{{{
  return max([&winminheight, get(g:, 'streatch_winminheight', 2)])
endfunction "}}}

" Initialization {{{1



" 1}}}
