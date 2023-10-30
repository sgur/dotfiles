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

" 2}}}

let g:lsp_async_completion = 1

if has('win32')
  let g:lsp_settings_servers_dir = expand('~/.local/share/vim-lsp-settings/servers')
  let g:lsp_settings_global_settings_dir = expand('~/.local/share/vim-lsp-settings')
endif

let g:lsp_log_verbose = 3
let g:lsp_log_file = expand('~/.cache/vim-lsp/vim-lsp.log')

let g:lsp_popup_menu_server_blacklist = get(g:, 'lsp_popup_menu_server_blacklist', ['efm-langserver'])

let g:lsp_diagnostics_float_cursor = has('patch-8.1.1364')
let g:lsp_diagnostics_echo_cursor = !g:lsp_diagnostics_float_cursor
let g:lsp_diagnostics_float_cursor = exists('*popup_create')
let g:lsp_diagnostics_virtual_text_enabled = v:false && has('textprop') && has('patch-9.0.0178')
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = get(g:, 'lsp_diagnostics_virtual_text_enabled', 0) && has('textprop') && has('patch-9.0.0178')
let g:lsp_diagnostics_virtual_text_align = 'above'
let g:lsp_diagnostics_virtual_text_padding_left = 4
let g:lsp_diagnostics_virtual_text_prefix = "--- "
let g:lsp_diagnostics_virtual_text_wrap = "truncate"

let g:lsp_inlay_hints_enabled = has('textprop') && has('patch-9.0.0167')

try
  " 後に packadd! したものの方が先に読まれるため、ロードと逆順なる
  packadd! vim-vsnip-integ
  packadd! asyncomplete-lsp.vim
  packadd! vim-lsp-settings
  packadd! vim-lsp
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
  autocmd FileType lsp-quickpick-filter  setlocal iminsert=0
  " autocmd CursorHold *  call s:lsp_hover_command()
augroup END

function! s:lsp_hover_command() abort "{{{
  let hover_enabled_servers =
        \ lsp#get_allowed_servers()
        \ ->filter({k, v -> v != 'efm-langserver'})
        \ ->filter({k, v -> lsp#get_server_status(v) == 'running'})
        \ ->filter({k, v -> get(lsp#get_server_capabilities(v), 'hoverProvider', v:false) })
  let hover_command = empty(hover_enabled_servers) ? "LspHover" : "LspHover --server=" .. hover_enabled_servers[0]
  execute hover_command
endfunction "}}}

function! s:buffer_setup() abort "{{{
  nmap <silent> <expr> [g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-previous-diagnostic)" : ":\<C-u>cprevious\<CR>"

  nmap <silent> <expr> ]g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-next-diagnostic)" : ":\<C-u>cnext\<CR>"
  setlocal tagfunc=lsp#tagfunc
  setlocal omnifunc=lsp#omni#complete

  " helix-like mappings
  nmap <buffer> ]d  <Plug>(lsp-next-diagnostic)
  nmap <buffer> [d  <Plug>(lsp-previous-diagnostic)

  nmap <buffer> <LocalLeader>s <Plug>(lsp-document-symbol)
  nmap <buffer> <LocalLeader>S <Plug>(lsp-workspace-symbol)
  nmap <buffer> <LocalLeader>d <Plug>(lsp-document-diagnostics)
  nmap <buffer> <LocalLeader>a <Plug>(lsp-code-action)
  nmap <buffer> <LocalLeader>k <Plug>(lsp-hover)
  nmap <buffer> <LocalLeader>f <Plug>(lsp-document-format)
  nmap <buffer> <LocalLeader>r <Plug>(lsp-rename)

  nmap <buffer> <LocalLeader>gd <Plug>(lsp-definition)
  nmap <buffer> <LocalLeader>gD <Plug>(lsp-declaration)
  nmap <buffer> <LocalLeader>gi <Plug>(lsp-implementation)
  nmap <buffer> <LocalLeader>gr <Plug>(lsp-references)
  nmap <buffer> <LocalLeader>gy <Plug>(lsp-type-definition)

  nmap <buffer> [d  <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]d  <Plug>(lsp-next-diagnostic)
endfunction "}}}

" Icons {{{2
let s:icons_dir = expand(expand('<sfile>:p:h') . '/bitmaps/lsp-icons/')
let s:icon_ext = has('win32') ? '.ico' : '.png'
let s:emoji_text = v:true
function! s:lsp_icon_setup() abort "{{{
  let g:lsp_diagnostics_signs_enabled = 1
  let g:lsp_diagnostics_signs_error = {'text': s:emoji_text ? '😈' : '>', 'icon': s:icons_dir . 'twitter/smiling-face-with-horns' . s:icon_ext}
  let g:lsp_diagnostics_signs_warning = {'text': s:emoji_text ? '🤔' : 'v', 'icon': s:icons_dir . 'twitter/thinking-face' . s:icon_ext}
  let g:lsp_diagnostics_signs_information = {'text': s:emoji_text ? '🗨️' : '!', 'icon': s:icons_dir . 'twitter/left-speech-bubble' . s:icon_ext}
  let g:lsp_diagnostics_signs_hint = {'text': s:emoji_text ? '💡' :'?', 'icon': s:icons_dir . 'twitter/light-bulb' . s:icon_ext}
  let g:lsp_document_code_action_signs_enabled = 1
  let g:lsp_document_code_action_signs_hint = {'text': s:emoji_text ? '💡' :'?', 'icon': s:icons_dir . 'twitter/light-bulb' . s:icon_ext}
endfunction "}}}

" vim-lsp-settings {{{1

let s:lsp_settings_javascript_langservers = ['typescript-language-server', 'eslint-language-server', 'tailwindcss-intellisense']
let g:lsp_settings_filetype_javascript = s:lsp_settings_javascript_langservers
let g:lsp_settings_filetype_javascriptreact = s:lsp_settings_javascript_langservers
let g:lsp_settings_filetype_typescript = s:lsp_settings_javascript_langservers + ['deno']
let g:lsp_settings_filetype_typescriptreact = s:lsp_settings_javascript_langservers

let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver']

let g:lsp_settings_filetype_python = ['pylsp-all', 'pyright-langserver', 'ruff-lsp']

let g:lsp_settings = get(g:, 'lsp_settings', {})

" efm-langserver "{{{2
" Make sure to define $HOME on Windows
let g:lsp_settings['efm-langserver'] = #{
      \ allowlist: ['*'],
      \ disabled: !executable('go'),
      \ initialization_options: #{
      \   documentFormatting: v:true,
      \   hover: v:false,
      \   documentSymbol: v:true,
      \   codeAction: v:true,
      \   completion: v:true
      \ },
      \ cmd:
      \   {server_info -> [
      \     lsp_settings#exec_path('efm-langserver')]
      \     + lsp_settings#get('efm-langserver', 'args', [])
      \     + ['-c', expand("~/.config/efm-langserver/config.yaml")
      \   ]}
      \}

" eslint-language-server "{{{2
let g:lsp_settings['eslint-language-server'] = #{
      \ workspace_config: #{
      \   validate: 'probe',
      \   packageManager: 'yarn',
      \   codeActionOnSave: #{
      \     enable: v:true,
      \     mode: 'all',
      \   },
      \   codeAction: #{
      \     disableRuleComment: #{
      \       enable: v:true,
      \       location: 'separateLine',
      \     },
      \     showDocumentation: #{
      \       enable: v:true,
      \     },
      \   },
      \   format: v:false,
      \   quiet: v:false,
      \   onIgnoredFiles: 'off',
      \   options: {},
      \   run: 'onType',
      \   nodePath: v:null,
      \ },
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
      \ allowlist: ['typescript', 'typescript.tsx', 'typescriptreact'] +
      \            ['javascript', 'javascript.jsx', 'javascriptreact']
      \}

" markdown {{{2

" https://github.com/mattn/vim-lsp-settings/issues/527
let g:lsp_settings['remark-language-server'] = #{
      \ disabled: v:true
      \}

" Python {{{2
let g:lsp_settings['pylsp-all']= #{
      \ workspace_config: #{
      \   pylsp: #{
      \     configurationSources: ['flake8'],
      \     plugins: #{
      \       autopep8: #{ enabled: v:false },
      \       mccabe: #{ enabled: v:false },
      \       pycodestyle: #{ enabled: v:false },
      \       pyflakes: #{ enabled: v:false },
      \       yapf: #{ enabled: v:false },
      \     }
      \   }
      \ }
      \}

" C/C++ {{{2
" let g:lsp_settings['clangd'] = {}
" Dockerfile {{{2
" let g:lsp_settings['docker-langserver'] = {}

" Dart {{{2
" let g:lsp_settings['analysis-server-dart-snapshot'] = {}

" Bash {{{2
let g:lsp_settings['bash-language-server'] = #{
      \ allowlist: ['sh', 'bash'],
      \}

" XML {{{2
" let g:lsp_settings['lsp4xml'] = {}

" Java {{{2
" let g:lsp_settings['eclipse-jdt-ls'] = {}

" Csharp {{{2
" let g:lsp_settings['omnisharp-lsp'] = #{}

" Tailwind CSS  {{{2
let g:lsp_settings['tailwindcss-intellisense'] = #{
      \ allowlist: ['typescriptreact', 'javascriptreact', 'html', 'css', 'svelte', 'mdx'],
      \}
" }}}

if executable('npx')
  augroup vimrc_plugin_lsp_obisidian-lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'obsidian-lsp',
          \ cmd: {server_info->[exepath('npx'), '--yes', 'obsidian-lsp', '--stdio']},
          \ root_ui: {server_info->lsp#utils#path_to_uri(
          \	  lsp#utils#find_nearest_parent_file_directory(
          \	    lsp#utils#get_buffer_path(), ['.obsidian/']
          \	  ))},
          \ allowlist: ['markdown'],
          \ blocklist: [],
          \ config: {},
          \ workspace_config: {},
          \ languageId: {server_info->'markdown'},
          \})
  augroup END
endif

if !has('vim_starting')
  runtime! plugin/lsp.vim
  runtime! plugin/asyncomplete-lsp.vim
  runtime! plugin/lsp_settings.vim
  runtime! plugin/vsnip_integ.vim
  call lsp#enable()
  execute 'doautocmd' 'BufReadPost' expand('%')
endif
" vim:set filetype=vim:
