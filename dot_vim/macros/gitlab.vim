scriptencoding utf-8



" Internal {{{1

" https://gitlab.com/help/api/session.md
function! s:session_login() abort "{{{
  let res = webapi#http#post(printf('https://gitlab.com/api/v3/session?login=%s&password=%s', input('Username: '), inputsecret('Password: ')))
  if str2nr(res.status) != 201
    echohl 'Gitlab:' res.status res.message
    return {}
  endif
  let json = json_decode(res.content)
  return {
        \   'username': json.username
        \ , 'id': json.id
        \ , 'private_token': json.private_token
        \ }
endfunction "}}}

function! s:projects_list(token) abort "{{{
  let res = webapi#http#get('https://gitlab.com/api/v3/projects', {'private_token': a:token})
  if str2nr(res.status) != 200
    echohl 'gitlab:' res.status res.message
    return
  endif

  let json = json_decode(res.content)
  pp json
endfunction "}}}

function! s:projects_get(token, id) abort "{{{
  let res = webapi#http#get(printf('https://gitlab.com/api/v3/projects/%s', a:id), {'private_token': a:token})
  echo res
  if str2nr(res.status) != 200
    echohl 'gitlab:' res.status res.message
    return
  endif

  let json = json_decode(res.content)
  pp json
endfunction "}}}


function! s:project_snippets_list(token, project_id) abort "{{{
  let res = webapi#http#get(printf('https://gitlab.com/api/v3/projects/%d/snippets', a:project_id), {'private_token': a:token})
  if str2nr(res.status) != 200
    echohl 'Gitlab:' res.status res.message
    return
  endif

  let json = json_decode(res.content)
  PP json
endfunction "}}}

" Interface {{{1


" Initialization {{{1


if !exists('s:private_token') || empty(s:private_token)
  let session = s:session_login()
  let s:private_token = get(session, 'private_token', '')
  let s:user_id = get(session, 'id', '')
endif
call s:projects_get(s:private_token, 'snippets')


" 1}}}
