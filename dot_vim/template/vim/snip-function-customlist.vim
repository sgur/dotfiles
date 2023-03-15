function! {{_cursor_}}(arglead, cmdline, cursorpos) abort "{{{
  let _ = []
  return filter(_, 'stridx(v:val, a:arglead) == 0')
endfunction "}}}
