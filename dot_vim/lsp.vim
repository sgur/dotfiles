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
  packadd! asyncomplete.vim
  packadd! asyncomplete-buffer.vim
  packadd! asyncomplete-file.vim
  packadd! asyncomplete-lsp.vim
  packadd! vim-lsp-settings
  packadd! vim-lsp
  source <sfile>:h/lsp-settings.vim
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry

" asyncomplete  {{{2
function! s:on_bufwinenter_asyncomplete() abort "{{{
  let b:asyncomplete_enable = !&readonly
endfunction "}}}
inoremap <C-Space> <Plug>(asyncomplete_force_refresh)
augroup vimrc_plugin_asyncomplete
  autocmd!
  autocmd BufWinEnter *  call s:on_bufwinenter_asyncomplete()
  autocmd OptionSet readonly  call s:on_bufwinenter_asyncomplete()
augroup END
" file source
autocmd vimrc_plugin_asyncomplete User asyncomplete_setup
      \ call asyncomplete#register_source(asyncomplete#sources#file#get_source_options(#{
      \   name: 'asyncomplete_file',
      \   allowlist: ['vim', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'css', 'markdown'],
      \   completor: function('asyncomplete#sources#file#completor')
      \}))

if argc(-1) > 0
  autocmd vimrc_plugin_asyncomplete VimEnter *  call asyncomplete#enable_for_buffer()
endif

" 2}}}

let g:lsp_async_completion = 1

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
  nmap <silent> <expr> [g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-previous-diagnostic)" : ":\<C-u>cprevious\<CR>"

  nmap <silent> <expr> ]g max(values(lsp#get_buffer_diagnostics_counts())) > 0 ? "\<Plug>(lsp-next-diagnostic)" : ":\<C-u>cnext\<CR>"
  setlocal tagfunc=lsp#tagfunc
  setlocal omnifunc=lsp#omni#complete

  " helix-like mappings
  nmap <buffer> ]d  <Plug>(lsp-next-diagnostic)
  nmap <buffer> [d  <Plug>(lsp-previous-diagnostic)

  nmap <buffer> <Leader>d <Plug>(lsp-document-diagnostics)
  nmap <buffer> <Leader>s <Plug>(lsp-document-symbol)
  nmap <buffer> <Leader>S <Plug>(lsp-workspace-symbol)
  nmap <buffer> <Leader>a <Plug>(lsp-code-action)
  nmap <buffer> <Leader>k <Plug>(lsp-hover)
  nmap <buffer> <Leader>r <Plug>(lsp-rename)

  nmap <buffer> <Leader>gd <Plug>(lsp-definition)
  nmap <buffer> <Leader>gD <Plug>(lsp-declaration)
  nmap <buffer> <Leader>gi <Plug>(lsp-implementation)
  nmap <buffer> <Leader>gr <Plug>(lsp-references)
  nmap <buffer> <Leader>gy <Plug>(lsp-type-definition)

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
          \ name: 'buffer-ls',
          \ allowlist: ['*'],
          \ blocklist: [],
          \ cmd: {server_info -> [lsp_settings#exec_path('simple-completion-language-server')]},
          \ workspace_config: #{
          \   max_completion_items: 20,
          \   snippets_first: v:false,
          \   feature_words: v:true,
          \   feature_unicode_input: v:true,
          \   feature_paths: v:true
          \ }
          \})
  elseif executable('buffer-language-server')
    " buffer-language-server {{{3
    " https://github.com/metafates/buffer-language-server
    " $ cargo install buffer-language-server
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'buffer-ls',
          \ allowlist: ['*'],
          \ blocklist: [],
          \ cmd: {server_info -> [lsp_settings#exec_path('buffer-language-server')]}
          \})
  else
    " buffer source
    autocmd User asyncomplete_setup
          \  asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \   name: 'asyncomplete_buffer',
          \   allowlist: ['*'],
          \   completor: function('asyncomplete#sources#buffer#completor')
          \}))
  endif
augroup END

" obsidian-lsp {{{2
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

  " biome lsp-proxy {{{3
  augroup vimrc_plugin_lsp_biome
    autocmd!
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'biome-lsp',
          \ allowlist: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'],
          \ blocklist: [],
          \ cmd: {server_info -> [exepath('pnpm'), '--silent', 'dlx', '@biomejs/biome', 'lsp-proxy']}
          \})
  augroup END

  augroup vimrc_plugin_lsp_obisidian-lsp
    autocmd!
    autocmd User lsp_setup call lsp#register_server(#{
          \ name: 'obsidian-lsp',
          \ cmd: {server_info->[exepath('pnpm'), '--silent', 'dlx', 'obsidian-lsp', '--stdio']},
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
