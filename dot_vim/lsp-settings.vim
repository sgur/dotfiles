" vim-lsp-settings {{{1

if has('win32')
  let g:lsp_settings_servers_dir = expand('~/.local/share/vim-lsp-settings/servers')
  let g:lsp_settings_global_settings_dir = expand('~/.local/share/vim-lsp-settings')
endif

let s:lsp_settings_common_langservers = ['efm-langserver', 'buffer-ls']
let s:lsp_settings_javascript_langservers = ['typescript-language-server', 'eslint-language-server', 'tailwindcss-intellisense'] + s:lsp_settings_common_langservers
let g:lsp_settings_filetype_javascript = s:lsp_settings_javascript_langservers
let g:lsp_settings_filetype_javascriptreact = g:lsp_settings_filetype_javascript
let g:lsp_settings_filetype_typescript = s:lsp_settings_javascript_langservers + ['deno']
let g:lsp_settings_filetype_typescriptreact = g:lsp_settings_filetype_typescript

let g:lsp_settings_filetype_go = ['gopls', 'golangci-lint-langserver'] + s:lsp_settings_common_langservers

let g:lsp_settings_filetype_python = ['pylsp-all', 'pyright-langserver', 'ruff-lsp'] + s:lsp_settings_common_langservers

let g:lsp_settings = get(g:, 'lsp_settings', {})

" efm-langserver "{{{2
" Make sure to define $HOME on Windows
let g:lsp_settings['efm-langserver'] = #{
      \ disabled: v:false,
      \ allowlist:  ['*'],
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
" }}}
