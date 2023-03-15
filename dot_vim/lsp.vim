"                   ___         ___
"                  /  /\       /  /\
"                 /  /:/_     /  /::\
"   ___     ___  /  /:/ /\   /  /:/\:\
"  /__/\   /  /\/  /:/ /::\ /  /:/~/:/
" \  \:\ /  /:/__/:/ /:/\:/__/:/ /:/
"  \  \:\  /:/\  \:\/:/~/:\  \:\/:/
"   \  \:\/:/  \  \::/ /:/ \  \::/
"    \  \::/    \__\/ /:/   \  \:\
"     \__\/       /__/:/     \  \:\
"                 \__\/       \__\/
"
" http://patorjk.com/software/taag/ - Isometric 3 Smush (U)
scriptencoding utf-8

if &readonly || !&loadplugins
  finish
endif

" setup {{{1

let s:rc_dir = expand('<sfile>:p:h:gs?\?/?')
let s:temp_dir = fnamemodify(tempname(), ':p:h')

" log {{{2
let g:lsp_log_file = expand(s:temp_dir . '/vim-lsp.log')
let g:efm_langserver_log_file = expand(s:temp_dir . '/efm-langserver.log')
let g:lsp_log_file = ''
" 2}}}

let g:lsp_async_completion = 1
if has('win32')
  let g:lsp_settings_servers_dir = expand('~/.local/share/vim-lsp-settings/servers')
  let g:lsp_settings_global_settings_dir = expand('~/.local/share/vim-lsp-settings')
endif

let g:lsp_diagnostics_float_cursor = has('patch-8.1.1364')
let g:lsp_diagnostics_echo_cursor = !g:lsp_diagnostics_float_cursor

let g:vista_default_executive = 'vim_lsp'

let g:lsp_popup_menu_server_blacklist = get(g:, 'lsp_popup_menu_server_blacklist', ['efm-langserver'])

try
  packadd! vim-lsp
  packadd! asyncomplete-lsp.vim
  packadd! vim-lsp-settings
  packadd! vim-vsnip-integ
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry


" vim-lsp {{{1

function! s:on_bufwinenter_lsp() abort "{{{
  let path = expand('%:p')
  if &readonly || stridx(path, '\\') == 0 || stridx(path, '/mnt') == 0
    call lsp#disable_diagnostics_for_buffer()
  else
    call lsp#enable_diagnostics_for_buffer()
  endif
endfunction "}}}
call s:on_bufwinenter_lsp()

" https://github.com/prabirshrestha/vim-lsp/wiki/Servers
augroup vimrc_plugin_lsp
  autocmd!
  autocmd User lsp_setup  autocmd! vim_lsp_suggest
  autocmd User lsp_setup call s:lsp_icon_setup()
  autocmd User lsp_setup  call lsp_popup_menu#setup()
  autocmd User lsp_buffer_enabled  call s:buffer_setup()
  autocmd User lsp_buffer_enabled  call lsp_popup_menu#enable()
  autocmd BufWinEnter *  call s:on_bufwinenter_lsp()
  autocmd OptionSet readonly  call s:on_bufwinenter_lsp()
augroup END

command! -nargs=0 LspListCapabilities
      \ call s:get_capabilities()->map("execute('echo v:val', 0)")

function! s:get_capabilities() abort "{{{
  let capabilities = []
  for s in lsp#get_allowed_servers()
    let capability = lsp#get_server_capabilities(s)
    let available = filter(keys(capability), {k,v -> !(type(capability[v]) == type(v:t_bool) && capability[v] == v:false)})
    let capabilities += available
  endfor
  call uniq(sort(capabilities))
  return capabilities
endfunction "}}}

function! s:buffer_setup() abort "{{{
  if exists('b:lsp_capabilities')
    return
  endif
  let b:lsp_capabilities = s:get_capabilities()

  nmap <silent> <expr> [g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-previous-diagnostic)" : ":\<C-u>cprevious\<CR>"
  nmap <silent> <expr> ]g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-next-diagnostic)" : ":\<C-u>cnext\<CR>"
  setlocal tagfunc=lsp#tagfunc
  setlocal omnifunc=lsp#omni#complete

  nmap <buffer> <C-LeftMouse>  <plug>(lsp-definition)
  nmap <buffer> <LocalLeader>ca <Plug>(lsp-code-action)
  nmap <buffer> <LocalLeader>cl <Plug>(lsp-code-lens)
  nmap <buffer> <LocalLeader>dec <Plug>(lsp-declaration)
  nmap <buffer> <LocalLeader>def <Plug>(lsp-definition)
  nmap <buffer> <LocalLeader>dd <Plug>(lsp-document-diagnostics)
  nmap <buffer> <LocalLeader>df <Plug>(lsp-document-format)
  vmap <buffer> <LocalLeader>df <Plug>(lsp-document-format)
  nmap <buffer> <LocalLeader>h <Plug>(lsp-hover)
  nmap <buffer> <LocalLeader>impl <Plug>(lsp-implementation)
  nmap <buffer> <LocalLeader>pdec <Plug>(lsp-peek-declaratioN)
  nmap <buffer> <LocalLeader>pdef <Plug>(lsp-peek-definition)
  nmap <buffer> <LocalLeader>pimpl <plug>(lsp-peek-implementation)
  nmap <buffer> <LocalLeader>ptdef <plug>(lsp-peek-type-definition)
  nmap <buffer> <LocalLeader>ref <Plug>(lsp-references)
  nmap <buffer> <LocalLeader>ren <Plug>(lsp-rename)
  nmap <buffer> <LocalLeader>sig <Plug>(lsp-signature-help)
  nmap <buffer> <LocalLeader>st <Plug>(lsp-status)
  nmap <buffer> <LocalLeader>tdef <Plug>(lsp-type-definition)
  nmap <buffer> <LocalLeader>ws <Plug>(lsp-workspace-symbol)
endfunction "}}}

" Icons {{{2
let s:icons_dir = expand(expand('<sfile>:p:h') . '/bitmaps/lsp-icons/')
let s:icon_ext = has('win32') ? '.ico' : '.png'
function! s:lsp_icon_setup() abort "{{{
  let g:lsp_diagnostics_signs_enabled = 1
  let g:lsp_diagnostics_signs_error = {'text': '>', 'icon': s:icons_dir . 'error' . s:icon_ext}
  let g:lsp_diagnostics_signs_warning = {'text': 'v', 'icon': s:icons_dir . 'warning' . s:icon_ext}
  let g:lsp_diagnostics_signs_information = {'text': '!', 'icon': s:icons_dir . 'information' . s:icon_ext}
  let g:lsp_diagnostics_signs_hint = {'text': '?', 'icon': s:icons_dir . 'hint' . s:icon_ext}
  let g:lsp_document_code_action_signs_enabled = 1
  let g:lsp_document_code_action_signs_hint = {'text': '?', 'icon': s:icons_dir . 'hint' . s:icon_ext}
endfunction "}}}

" vim-lsp-settings {{{1

let g:lsp_settings = get(g:, 'lsp_settings', {})

" efm-langserver "{{{2
" Make sure to define $HOME on Windows
let g:lsp_settings['efm-langserver'] = #{
      \ allowlist: ['*'],
      \ disabled: !executable('go'),
      \ initialization_options: #{
      \   documentFormatting: v:true,
      \   hover: v:true,
      \   documentSymbol: v:true,
      \   codeAction: v:true,
      \   completion: v:true
      \ },
      \ cmd: {server_info -> empty(lsp_settings#exec_path('efm-langserver'))
      \   ? []
      \   : [lsp_settings#exec_path('efm-langserver')] + lsp_settings#get('efm-langserver', 'args', [])
      \     + ['-c', expand("~/.config/efm-langserver/config.yaml")]
      \     + (!empty(get(g:, 'efm_langserver_log_file', '')) ? ['-logfile', g:efm_langserver_log_file] : [])}
      \}

" Html {{{2
" let g:lsp_settings['html-languageserver'] = {}

" JSON {{{2
" let g:lsp_settings['json-languageserver'] = {}

" Yaml {{{2
let g:lsp_settings['yaml-language-server'] = #{
      \ allowlist: ['yaml', 'yaml.docker-compose'],
      \	languageId: {server_info-> 'yaml'},
      \ workspace_config: #{
      \   yaml: #{
      \     schemas: {
      \       'https://cdn.statically.io/gh/awslabs/goformation/master/schema/cloudformation.schema.json': 'template*.yaml',
      \       'https://cdn.statically.io/gh/compose-spec/compose-spec/master/schema/compose-spec.json': 'docker-compose.yaml'
      \     },
      \     customTags: [
      \       '!And sequence',
      \       '!Base64',
      \       '!Cidr sequence',
      \       '!Equals sequence',
      \       '!FindInMap sequence',
      \       '!Fn',
      \       '!GetAZs',
      \       '!GetAtt',
      \       '!If sequence',
      \       '!ImportValue',
      \       '!Join sequence',
      \       '!Not sequence',
      \       '!Or sequence',
      \       '!Ref',
      \       '!Select sequence',
      \       '!Split sequence',
      \       '!Sub'
      \     ]
      \   }
      \ }
      \}

" VimL {{{2
let g:lsp_settings['vim-language-server'] = #{
      \ initialization_options: #{
      \   iskeyword: '@,48-57,_,192-255,-#',
      \   vimruntime: $VIMRUNTIME,
      \   runtimepath: &packpath . ',' . join(globpath(&packpath, 'pack/*/*/*', 1, 1), ','),
      \   diagnostic: #{
      \     enable: v:true
      \   },
      \   indexes: #{
      \     runtimepath: v:true,
      \     gap: 50,
      \     count: 6,
      \   },
      \   suggest: #{
      \     fromVimruntime: v:true,
      \     fromRuntimepath: v:true
      \   }
      \ },
      \ whitelist: ['vim', 'help']
      \}

" Elm {{{2
" let g:lsp_settings['elm-language-server'] = {}

" CSS {{{2
" let g:lsp_settings['css-languageserver'] = {}

" Go {{{2
let g:lsp_settings['gopls'] = #{
      \ initialization_options: #{
      \   analyses: #{
      \     fillstruct: v:true
      \   }
      \ }
      \}

" JavaScript, Typescript {{{2
let g:lsp_settings['typescript-language-server'] = #{
      \ whitelist: ['typescript', 'typescript.tsx', 'typescriptreact'] +
      \            ['javascript', 'javascript.jsx', 'javascriptreact']
      \}

" markdown {{{2

" https://github.com/mattn/vim-lsp-settings/issues/527
let g:lsp_settings['remark-language-server'] = #{
      \ disabled: v:true
      \}

" Python {{{2

" C/C++ {{{2
" let g:lsp_settings['clangd'] = {}
" Dockerfile {{{2
" let g:lsp_settings['docker-langserver'] = {}

" Dart {{{2
" let g:lsp_settings['analysis-server-dart-snapshot'] = {}

" Bash {{{2
let g:lsp_settings['bash-language-server'] = #{
      \ whitelist: ['sh', 'bash'],
      \}

" XML {{{2
" let g:lsp_settings['lsp4xml'] = {}

" Java {{{2
" let g:lsp_settings['eclipse-jdt-ls'] = {}

" Csharp {{{2
" let g:lsp_settings['omnisharp-lsp'] = #{}

" }}}

if !has('vim_starting')
  runtime! plugin/lsp.vim
  runtime! plugin/lsp_settings.vim
  runtime! plugin/asyncomplete-lsp.vim
  runtime! plugin/vsnip_integ.vim
  call lsp#enable()
  execute 'doautocmd' 'BufReadPost' expand('%')
endif
" vim:set filetype=vim:
