scriptencoding utf-8



" Interface {{{1

function! using_job#system(expr) abort
  return s:job_sync(a:expr)
endfunction

" Internal {{{1

function! s:job_sync_exit_cb(job, code) abort dict "{{{
  while ch_canread(a:job)
    let msg = ch_read(a:job)
    let self.lines += [msg]
  endwhile
endfunction "}}}

function! s:job_sync(expr) abort "{{{
  let opt = {'lines': []}
  let job = job_start(a:expr, {
        \ 'out_cb': {ch, msg -> add(opt.lines, msg)},
        \ 'exit_cb': function('s:job_sync_exit_cb', [], opt)
        \ })
  while job_status(job) is# 'run'
    sleep 10m
  endwhile
  if filewritable(g:job_sync_log)
    let dir = fnamemodify(g:job_sync_log, ':p:h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
    call writefile([strftime('---- %c ----')] + opt.lines, g:job_sync_log)
  endif
  return join(opt.lines, "\n")
endfunction "}}}


" Initialization {{{1

let g:job_sync_log = get(g:, 'job_sync_log', '')


" 1}}}
