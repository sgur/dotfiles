scriptencoding utf-8
scriptversion 3

if exists('g:loaded_ctrlp_zoxide') && g:loaded_ctrlp_zoxide
  finish
endif
let g:loaded_ctrlp_zoxide = 1

let s:zoxide_var = {
\  'init':   'ctrlp#zoxide#init()',
\  'accept': 'ctrlp#zoxide#accept',
\  'lname':  'zoxide',
\  'sname':  'zoxide',
\  'type':   'path',
\  'sort':   0,
\  'nolim':  1,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:zoxide_var)
else
  let g:ctrlp_ext_vars = [s:zoxide_var]
endif

let s:zoxide_command = get(g:, 'ctrlp_zoxide_command', 'zoxide')

function! ctrlp#zoxide#init()
  return systemlist('zoxide query --list')
endfunc

function! ctrlp#zoxide#accept(mode, str) abort
  call system('zoxide add ' .. shellescape(a:str))
  call ctrlp#exit()
  const actions = get(g:, 'ctrlp_zoxide_actions', [])
  if a:mode != 'm' || empty(actions) || type(actions) != v:t_list
    call ctrlp#setdir(a:str)
  else
    let choice = confirm("Action?", join(map(copy(actions), 'v:val["label"]'), "\n"))
    redraw
    if choice == 0
      return
    endif
    let act = actions[choice-1]
    let action = get(act, 'action', action)
    let path = get(act, 'path', 1) ? path : a:str
    exec action a:str
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#zoxide#id()
  return s:id
endfunction

