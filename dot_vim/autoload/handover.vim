scriptencoding utf-8



" Interface {{{1

" Quit  'q'
" Ask   ''
function! handover#detect(fname_unescape) abort
  for server in split(serverlist(), "\n")
    if server ==? v:servername
      continue
    endif

    let fname = s:expr_escape(a:fname_unescape)
    if remote_expr(server, "bufloaded('" . fname . "')")
      call s:focus(server)

      try
        if exists('v:swapcommand')
          let choice = substitute(v:swapcommand, "'", "''", 'g')
          call remote_expr(server, "handover#edit('" . fname . "', '" . choice . "')")
        else
          call remote_expr(server, "handover#edit('" . fname . "', '')")
        endif
      endtry
      if !has('vim_starting') || !has('gui_running') || !has('gui_win32')
        echomsg 'File is being edited by' server
      endif
      return 'q'
    endif
  endfor
  return ''
endfunction

function! handover#edit(fname, choice) abort
  let bufnr = bufnr(a:fname)
  let [tabnr, winnr] = s:find_buf(bufnr)

  execute 'tabnext' tabnr
  if winnr
    execute winnr . 'wincmd w'
  else
    execute 'split' fnameescape(a:fname)
  endif

  if !empty(a:choice)
    execute 'normal!' a:choice
  endif
endfunction


" Internal {{{1

function! s:expr_escape(src) abort "{{{
  return substitute(a:src, "'", "''", 'g')
endfunction "}}}

function! s:focus(servername) abort "{{{
  call remote_foreground(a:servername)
  call remote_expr(a:servername, 'foreground()')
endfunction "}}}

function! s:find_buf(bufnr) abort "{{{
  for tabnr in range(1, tabpagenr('$'))
    let found = filter(tabpagebuflist(tabnr), 'v:val == a:bufnr')
    if !empty(found)
      return [tabnr, bufwinnr(a:bufnr)]
    endif
  endfor
  return [1, 0]
endfunction "}}}


" Initialization {{{1



" 1}}}
