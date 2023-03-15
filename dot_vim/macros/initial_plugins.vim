scriptencoding utf-8

let s:packpath = get(split(&packpath, ','), 0, '')
if empty(s:packpath)
  finish
endif
let s:info = [
      \ {
      \   'type': 'opt',
      \   'depth': 1,
      \   'url': 'https://github.com/k-takata/minpac.git'
      \ }]

function! s:on_exit(job, status) dict abort "{{{
  if a:status == 0
    if has_key(self, 'do')
      let dir = expand(self.__dir . fnamemodify(self.url, ':t:r'))
      call job_start(self.do, {'cwd': dir})
    endif
    execute 'bdelete!' self.__bufnr
  endif
endfunction "}}}

function! s:clone_minpac()
  let packdir = expand(s:packpath . '/pack')
  for info in s:info
    let info.__dir = fnamemodify(printf('%s/minpac/%s', packdir, info.type), ':p')
    if !isdirectory(info.__dir)
      call mkdir(info.__dir, 'p')
    endif

    try
      let bufnr = term_start(['git', 'clone', info.url] +
            \ (has_key(info, 'depth') ? ['--depth=' . info.depth] : []), {
            \ 'cwd': info.__dir,
            \ 'exit_cb': function('s:on_exit', [], info),
            \})
      let info.__bufnr = bufnr
    endtry
  endfor

  echomsg 'Done'
endfunction

call s:clone_minpac()
