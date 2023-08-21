scriptversion 4

function! asyncomplete#sources#dictionary#get_source_options(opts)
  let l:config = extend({
        \   'allow_first_capital_letter': v:false,
        \   'complete_min_chars': 5,
        \   'dictionary_file': '/usr/share/dict/words',
        \ },
        \ get(a:opts, 'config', {}))
  return extend({ 'config': l:config }, a:opts, 'keep')
endfunction

function! asyncomplete#sources#dictionary#completor(opt, ctx)
  let l:col = a:ctx['col']
  let l:typed = a:ctx['typed']

  let l:complete_min_chars = a:opt['config']['complete_min_chars']
  let l:dictionary_file = a:opt['config']['dictionary_file']

  let l:keyword = matchstr(l:typed, '\v[a-z,A-Z]{' .. l:complete_min_chars .. ',}$')
  let l:keyword_len = len(l:keyword)

  if l:keyword_len < l:complete_min_chars
    call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches, 1)
    return
  endif

  let l:start_col = l:col - l:keyword_len
  let l:info = { 'start_col': l:start_col, 'opt': a:opt, 'ctx': a:ctx, 'keyword': l:keyword, 'lines': [] }

  let l:cmd = s:grep_cmd + ['^' .. l:keyword]
  if l:dictionary_file != ''
    let l:cmd = l:cmd + [l:dictionary_file]
  endif

  call job_start(l:cmd, {
    \   'out_cb': function('s:out_handler', [l:info]),
    \   'exit_cb': function('s:exit_handler', [l:info])
    \ })
endfunction

function! s:out_handler(info, ch, msg) abort "{{{
  let a:info['lines'] += [a:msg]
endfunction "}}}

function! s:exit_handler(info, job, status) abort "{{{
  call asyncomplete#log('asyncomplete-dictionary.vim', 'exitcode', a:status)

  let l:ctx = a:info['ctx']
  let l:start_col = a:info['start_col']

  let l:matches = []
  let l:itembase = {'dup' : 1, 'icase' : 1, 'menu' : '[dict]' }

  let l:allow_first_capital_letter = a:info['opt']['config']['allow_first_capital_letter']

  for l:line in a:info['lines']
    let l:linesplit = split(l:line)

    if len(l:linesplit) != 0
      let l:item = copy(l:itembase)

      if l:allow_first_capital_letter && a:info['keyword'] =~# '^\u'
        let l:item['word'] = substitute(l:linesplit[0], '\w\+', '\u\0', 'c')
      else
        let l:item['word'] = l:linesplit[0]
      endif

      if len(l:linesplit) > 1
        let l:item['info'] = join(l:linesplit[1:], ' ')
      endif

      call add(l:matches, l:item)
    endif
  endfor

  call asyncomplete#complete(a:info['opt']['name'], l:ctx, l:start_col, l:matches)
endfunction "}}}

let s:grep_cmd = executable('rg')
      \ ? ['rg', '--no-line-number', '--color=never', '--max-count=5']
      \ : ['grep', '--color=never', '--max-count=5']
