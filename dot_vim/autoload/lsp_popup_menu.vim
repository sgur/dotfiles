scriptencoding utf-8

" TODO: normal mode と visual mode でマッピングを両方用意する


" Interface {{{1

function! lsp_popup_menu#setup() abort
  call s:setup_popup()
endfunction

function! lsp_popup_menu#enable() abort
  let servers = lsp#get_whitelisted_servers()
  if empty(servers)
    return
  endif
  let available_servers = s:filter_blacklist_server(servers)
  let capabilities = s:gather_capabilities(available_servers)
  " let functions = s:capabilites_to_functions(capabilities)
  " call s:setup_winbar(functions)
  let b:lsp_popup_menu_capabilities = capabilities
  call s:enable_popup(capabilities)
  augroup vim_lsp_popup
    autocmd!
    autocmd WinEnter <buffer>  call lsp_popup_menu#restore()
  augroup END
endfunction

function! lsp_popup_menu#restore() abort
  call s:disable_popup()
  if !exists('b:lsp_popup_menu_capabilities')
    return
  endif
  call s:enable_popup(b:lsp_popup_menu_capabilities)
endfunction

" Internal {{{1

function! s:filter_blacklist_server(servers) abort "{{{
  return filter(copy(a:servers), {k,v -> index(g:lsp_popup_menu_server_blacklist, v) == -1})
endfunction "}}}

function! s:gather_capabilities(servers) abort "{{{
  let capabilities = []
  for server in a:servers
    for [capability, status] in items(lsp#get_server_capabilities(server))
      if type(status) == type(v:false) && status == v:false
        continue
      endif
      let capabilities += [capability]
    endfor
  endfor
  return uniq(sort(capabilities))
endfunction "}}}

function! s:capabilites_to_functions(capabilities) abort "{{{
  let mapping = deepcopy(s:lsp_map_default)
  let functions = []
  for c in a:capabilities
    if !has_key(mapping, c) || empty(mapping[c])
      continue
    endif
    let lsp_cmd = mapping[c]
    let cmd_list = type(lsp_cmd) == type([]) ? lsp_cmd : [lsp_cmd]
    for cmd in cmd_list
      let functions += type(cmd) == type({})
            \ ? [cmd] : [{'label': substitute(cmd, '^Lsp', '', ''), 'cmd': cmd}]
    endfor
  endfor
  return functions
endfunction "}}}

function! s:setup_winbar(functions) abort "{{{
  let id = 20
  nunmenu WinBar
  nnoremenu 1.10 WinBar.Status :<C-u>call popup_dialog(split(lsp#get_server_status(), "\n"), {'close': 'click', 'drag': v:false, 'moved': 'any'})<CR>
  for f in a:functions
    execute printf('nnoremenu 1.%d WinBar.%s :<C-u>%s<CR>', id, f.label, f.cmd)
    let id += 10
  endfor
endfunction "}}}

function! s:setup_popup() abort "{{{
  anoremenu 1.200 PopUp.-SEP3-  <Nop>
  let id = 10
  for [capability, actions] in sort(items(s:lsp_map_default))
    let commands = type(actions) == type([]) ? actions : [actions]
    for command in commands
      execute printf('anoremenu 1.200.%d PopUp.Lsp.%s :<C-u>%s<CR>', id, command, command)
    endfor
    let id += 10
  endfor
endfunction "}}}

function! s:disable_popup() abort "{{{
  amenu disable PopUp.Lsp.*
endfunction "}}}

function! s:enable_popup(capabilities) abort "{{{
  call s:disable_popup()
  for capability in a:capabilities
    let actions = get(s:lsp_map_default, capability, v:none)
    if type(actions) == type(v:none) && actions == v:none
      continue
    endif
    let commands = type(actions) == type([]) ? actions : [actions]
    for command in commands
      execute printf('amenu enable PopUp.Lsp.%s', command)
    endfor
  endfor
endfunction "}}}


" Initialization {{{1

let s:lsp_map_default = {
      \ 'codeActionProvider': 'LspCodeAction',
      \ 'documentDiagnosticsProvider': 'LspDocumentDiagnostics',
      \ 'declarationProvider': ['LspDeclaration', 'LspPeekDeclaration'],
      \ 'definitionProvider': ['LspDefinition', 'LspPeekDefinition'],
      \ 'foldingRangeProvider': 'LspDocumentFold',
      \ 'documentFormattingProvider': ['LspDocumentFormat', 'LspDocumentRangeFormat'],
      \ 'documentSymbolProvider': 'LspDocumentSymbol',
      \ 'hoverProvider': 'LspHover',
      \ 'implementationProvider': ['LspImplementation', 'LspPeekImplementation'],
      \ 'referencesProvider': 'LspReferences',
      \ 'renameProvider': 'LspRename',
      \ 'signatureHelpProvider': 'LspSignatureHelp',
      \ 'typeDefinitionProvider': ['LspTypeDefinition', 'LspPeekTypeDefinition'],
      \ 'workspaceSymbolProvider': 'LspWorkspaceSymbol',
      \ }




" 1}}}
