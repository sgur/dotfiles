vim9script

if &readonly || !&loadplugins
  finish
endif

try
  packadd! vim-lsp-settings
  packadd! vim-lsp-settings-bridge
  packadd! lsp
  source <sfile>:h/lsp-settings.vim
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry

var lsp_options = {
  completionMatcher: 'fuzzy',
  diagSignErrorText: '😈',
  diagSignHintText: '💡',
  diagSignInfoText: '🗨️',
  diagSignWarningText: '🤔',
  echoSignature: v:true,
  omniComplete: v:true,
  showDiagWithVirtualText: has('patch-9.0.1157') != 0,
  showInlayHints: has('patch-9.0.0178') != 0,
  useBufferCompletion: v:true,
  vsnipSupport: v:true,
}

# servers

var lsp_servers: list<dict<any>> = []

## biome lsp-proxy
lsp_servers += [{
  name: 'biome-lsp',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'],
  path: exepath('npx'),
  args: ['--yes', '--', '@biomejs/biome', 'lsp-proxy', printf('--config-path="%s"', expand('~/.config/biome.json'))]
}]

# initialize

augroup vimrc_lsp_init
  autocmd!
  autocmd VimEnter *  g:LspOptionsSet(lsp_options)
  autocmd VimEnter *  g:LspAddServer(lsp_servers->filter((_, v) => !empty(v.path)))
augroup END



