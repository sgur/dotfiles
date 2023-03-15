scriptencoding utf-8



" Interface {{{1

function! proxy#detect(ssid, host, port) abort
  call s:reset_proxy()

  if has('osx')
    call s:proxy_required_on_osx(a:ssid, function('s:set_proxy', [a:host, a:port]))
  else
    call s:proxy_required_on_win32(a:ssid, function('s:set_proxy', [a:host, a:port]))
  endif
endfunction

" Internal {{{1

function! s:reset_proxy() abort "{{{
  let $ALL_PROXY = ''
  let $HTTP_PROXY = ''
  let $HTTPS_PROXY = ''
  let $GIT_SSH_COMMAND = ''
endfunction "}}}

function! s:set_proxy(host, port) abort "{{{
  let $ALL_PROXY = printf('%s:%d', a:host, a:port)
  let $HTTP_PROXY = printf('http://%s:%d/', a:host, a:port)
  let $HTTPS_PROXY = printf('http://%s:%d/', a:host, a:port)
  let $GIT_SSH_COMMAND = printf('ssh -oProxyCommand="connect -H %s:%d %%h %%p"', a:host, a:port)
endfunction "}}}

" Window {{{2

function! s:proxy_required_on_win32(ssid, fn) abort "{{{
  call job_start('netsh wlan show interfaces', {
        \ 'out_cb': function('s:netsh_callback', [a:ssid, a:fn])
        \ })
endfunction "}}}

function! s:netsh_callback(ssid, fn, ch, msg) abort "{{{
  let line = iconv(a:msg, &termencoding, &encoding)
  if line !~ '\<SSID'
    return
  endif
  let ssid = matchstr(line, '\s*SSID\s*:\s*\zs\(\S\+\)\ze\s*')
  if ssid is? a:ssid
    call a:fn()
  endif
endfunction "}}}

" MacOS {{{2

function! s:proxy_required_on_osx(ssid, fn) abort "{{{
  call job_start(['networksetup', '-getairportnetwork', 'en1'], {
        \ 'out_cb': function('s:networksetup_callback', [a:ssid, a:fn])
        \ })
endfunction "}}}

function! s:networksetup_callback(ssid, fn, ch, msg) abort "{{{
  if a:msg =~# 'You are not associated with an AirPort network' ||
        \ {val -> len(val) > 1 && val[1] == a:ssid}(split(a:msg, ': '))
    call a:fn()
  endif
endfunction "}}}

" 2}}}

" Initialization {{{1



" 1}}}
