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

try
  packadd! vim-lsp
  packadd! vim-lsp-settings
  packadd! asyncomplete.vim
  packadd! asyncomplete-lsp.vim
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry

" asyncomplete  {{{2
inoremap <C-Space> <Plug>(asyncomplete_force_refresh)
augroup vimrc_plugin_asyncomplete
  autocmd!
  " file source
  autocmd vimrc_plugin_asyncomplete FuncUndefined asyncomplete#sources#file#* packadd asyncomplete-file.vim
  autocmd vimrc_plugin_asyncomplete User asyncomplete_setup
        \ call asyncomplete#register_source(asyncomplete#sources#file#get_source_options(#{
        \   name: 'asyncomplete_file',
        \   allowlist: ['vim', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'markdown'],
        \   completor: function('asyncomplete#sources#file#completor')
        \}))

  if argc(-1) > 0
    autocmd vimrc_plugin_asyncomplete VimEnter *  call asyncomplete#enable_for_buffer()
  endif
augroup END

" 2}}}

let g:lsp_async_completion = 1
let g:lsp_use_native_client = has('patch-8.2.4780')
let g:lsp_use_lua = has('lua') && has('patch-8.2.0775')

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.cache/vim-lsp/vim-lsp.log')

let g:lsp_popup_menu_server_blacklist = get(g:, 'lsp_popup_menu_server_blacklist', ['efm-langserver'])

let g:lsp_diagnostics_float_cursor = has('patch-8.1.1364')
let g:lsp_diagnostics_echo_cursor = !g:lsp_diagnostics_float_cursor
let g:lsp_diagnostics_float_cursor = exists('*popup_create')
let g:lsp_diagnostics_virtual_text_enabled = has('textprop') && has('patch-9.0.0178')
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = get(g:, 'lsp_diagnostics_virtual_text_enabled', 0) && has('textprop') && has('patch-9.0.0178')
let g:lsp_diagnostics_virtual_text_align = 'after'
let g:lsp_diagnostics_virtual_text_padding_left = 1
let g:lsp_diagnostics_virtual_text_prefix = "── "

let g:lsp_inlay_hints_enabled = has('textprop') && has('patch-9.0.0167')

let g:lsp_code_action_ui = 'float'

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
  setlocal tagfunc=lsp#tagfunc
  setlocal omnifunc=lsp#omni#complete

  " helix-like mappings
  nmap <buffer> ]d  <Plug>(lsp-next-diagnostic)
  nmap <buffer> [d  <Plug>(lsp-previous-diagnostic)

  nmap <buffer> <Leader>s <Plug>(lsp-document-symbol)
  nmap <buffer> <Leader>S <Plug>(lsp-workspace-symbol)
  nmap <buffer> <Leader>d <Plug>(lsp-document-diagnostics)
  nmap <buffer> <Leader>a <Plug>(lsp-code-action)
  nmap <buffer> <Leader>k <Plug>(lsp-hover)
  nmap <buffer> <Leader>r <Plug>(lsp-rename)
  nmap <buffer> <Leader>h <plug>(lsp-references)

  nmap <buffer> gy <Plug>(lsp-type-definition)
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gD <Plug>(lsp-declaration)
  nmap <buffer> gI <Plug>(lsp-implementation)

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

" buffer-language-server {{{2
augroup vimrc_plugin_lsp_buffer
  autocmd!
  if executable('simple-completion-language-server')
    " simple-completion-language-server {{{3
    " https://github.com/estin/simple-completion-language-server
    " $ cargo install --git https://github.com/estin/simple-completion-language-server.git
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'scls',
          \ allowlist: ['*'],
          \ blocklist: [],
          \ cmd: {server_info -> [lsp_settings#exec_path('simple-completion-language-server')]},
          \ workspace_config: #{
          \   max_completion_items: 10,
          \   snippets_first: v:true,
          \   feature_words: v:true,
          \   feature_snippets: v:true,
          \   feature_unicode_input: v:true,
          \   feature_paths: v:true
          \ }
          \})
  else
    " buffer source
    autocmd FuncUndefined asyncomplete#sources#buffer#* packadd asyncomplete-buffer.vim
    autocmd User asyncomplete_setup
          \  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options(#{
          \   name: 'asyncomplete_buffer',
          \   allowlist: ['*'],
          \   completor: function('asyncomplete#sources#buffer#completor')
          \}))
  endif
augroup END

if executable('pnpm')
  augroup vimrc_plugin_lsp_vscode-markdown-language-server
    autocmd!
    if lsp_settings#exec_path('marksman')->empty()
      autocmd User lsp_setup call lsp#register_server(#{
            \ name: 'vscode-markdown-language-server',
            \ allowlist: ['markdown'],
            \ blocklist: [],
            \ cmd: {server_info -> [exepath('pnpm'), '--silent', '--package=vscode-langservers-extracted', 'dlx',
            \   'vscode-markdown-language-server', '--stdio']},
            \ languageId: {server_info->'markdown'},
            \})
    endif
  augroup END

" obsidian-lsp {{{3
  augroup vimrc_plugin_lsp_obisidian-lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'obsidian-lsp',
          \ cmd: {server_info->[exepath('pnpm'), '--silent', 'dlx', 'obsidian-lsp', '--stdio']},
          \ root_uri: {server_info->lsp#utils#path_to_uri(
          \   lsp#utils#find_nearest_parent_file_directory(
          \     lsp#utils#get_buffer_path(), ['.obsidian/']
          \   ))},
          \ allowlist: ['markdown'],
          \ blocklist: [],
          \ config: {},
          \ workspace_config: {},
          \ languageId: {server_info->'markdown'},
          \})
  augroup END
endif

" vim-lsp-settings {{{1

if has('win32')
  let g:lsp_settings_servers_dir = expand('~/.local/share/vim-lsp-settings/servers')
  let g:lsp_settings_global_settings_dir = expand('~/.local/share/vim-lsp-settings')
endif

let s:lsp_settings_common_langservers = ['efm-langserver', 'typos-lsp', 'copilot-language-server']
let s:lsp_settings_javascript_langservers = ['typescript-language-server', 'eslint-language-server', 'tailwindcss-intellisense'] + s:lsp_settings_common_langservers
let g:lsp_settings_filetype_javascript = s:lsp_settings_javascript_langservers
let g:lsp_settings_filetype_javascriptreact = g:lsp_settings_filetype_javascript
let g:lsp_settings_filetype_typescript = s:lsp_settings_javascript_langservers + ['deno']
let g:lsp_settings_filetype_typescriptreact = g:lsp_settings_filetype_typescript

let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver'] + s:lsp_settings_common_langservers

let g:lsp_settings_filetype_python = ['pylsp-all', 'pyright-langserver', 'ruff-lsp'] + s:lsp_settings_common_langservers

function! s:root_exists(markers) abort "{{{
  return !empty(lsp#utils#find_nearest_parent_file_directory(
        \   lsp#utils#get_buffer_path(), a:markers))
endfunction "}}}

let g:lsp_settings = get(g:, 'lsp_settings', {})

" copilot-language-server {{{2
let g:lsp_settings['copilot-language-server'] = #{
      \ disabled: v:false,
      \ allowlist: ['*']
      \}

" typos-lsp {{{2
let g:lsp_settings['typos-lsp'] = #{
      \ disabled: v:false,
      \ allowlist: ['*'],
      \}

" efm-langserver "{{{2
let g:lsp_settings['efm-langserver'] = #{
      \ disabled: v:false,
      \ allowlist: ['*'],
      \ initialization_options: #{
      \   documentFormatting: v:true,
      \   hover: v:true,
      \   documentSymbol: v:true,
      \   codeAction: v:true,
      \   completion: v:true
      \ }
      \}

" eslint-language-server "{{{2
let g:lsp_settings['eslint-language-server'] = #{
      \ cmd: {name, key -> s:root_exists([
      \   'eslint.config.js', 'eslint.config.cjs', 'eslint.config.mjs',
      \   '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.mjs'
      \ ])
      \   ? [lsp_settings#exec_path('eslint-language-server'), '--stdio']
      \   : []},
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
      \ alllowlist: ['vim', 'help']
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


" Python {{{2
let g:lsp_settings['pylsp-all']= #{
      \ workspace_config: #{
      \   pylsp: #{
      \     configurationSources: ['flake8'],
      \     plugins: #{
      \       autopep8: #{ enabled: v:false },
      \       flake8: #{ enabled: v:false },
      \       mccabe: #{ enabled: v:false },
      \       pycodestyle: #{ enabled: v:false },
      \       pydocstyle: #{ enabled: v:false },
      \       pyflakes: #{ enabled: v:false },
      \       rope_autoimport: #{ enabled: v:true },
      \       rope_completion: #{ enabled: v:true },
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

" Biome LSP  {{{2
let g:lsp_settings['biome'] = #{
      \ cmd: {name, key -> s:root_exists(['biome.json', 'biome.jsonc'])
      \   ? [lsp_settings#exec_path('biome'), 'lsp-proxy']
      \   : []},
      \}
" }}}

" vim:set filetype=vim:
