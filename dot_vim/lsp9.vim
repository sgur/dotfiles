vim9script

if &readonly || !&loadplugins
  finish
endif

try
  packadd lsp
  packadd vimcomplete
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry

# vimcomplete options
var options = {
  completor: { shuffleEqualPriority: true, postfixHighlight: true },
  buffer: { enable: true, priority: 10, urlComplete: true, envComplete: true },
  lsp: { enable: true, priority: 10 },
  vsnip: { enable: true, priority: 11 },
  vimscript: { enable: true, priority: 11 },
}
augroup vimrc_plugin_vimcomplete
  autocmd!
  autocmd VimEnter * g:VimCompleteOptionsSet(options)
augroup END

# options
var lsp_options = {
  completionMatcher: 'fuzzy',
  omniComplete: v:true,
  showDiagWithVirtualText: has('patch-9.0.1157') != 0,
  showInlayHints: has('patch-9.0.0178') != 0,
  useBufferCompletion: v:false,
  vsnipSupport: v:true,
}

# servers

var lsp_servers: list<dict<any>> = []

def GetLspServerPath(name: string): string
  return expand(name, v:true)->exepath()
enddef

## astro
lsp_servers += [{
  name: 'astro-ls',
  filetype: ['astro'],
  path: GetLspServerPath('astro-ls'),
}]

## bash
lsp_servers += [{
  name: 'bash-language-server',
  filetype: ['sh', 'bash'],
  path: GetLspServerPath('bash-language-server'),
  args: ["start"]
}]

## css
lsp_servers += [{
  name: 'vscode-css-language-server',
  filetype: ['css', 'less', 'sass', 'scss'],
  path: GetLspServerPath( "vscode-css-language-server"),
  args: ["--stdio"]
}]

lsp_servers += [{
  name: 'tailwindcss-language-server',
  filetype: ['css'],
  path: GetLspServerPath('tailwindcss-language-server'),
  args: ['--stdio'],
}]

lsp_servers += [{
  name: 'stylelint-lsp',
  filetype: ['css'],
  path: GetLspServerPath('stylelint-lsp'),
  args: ["--stdio"]
}]

lsp_servers += [{
  name: 'stylelint-lsp-scss',
  filetype: ['less', 'sass', 'scss'],
  path: GetLspServerPath('stylelint-lsp-scss'),
  args: ["--stdio"]
}]

## dockefile
lsp_servers += [{
  name: 'docker-langserver',
  filetype: ['dockerfile'],
  path: GetLspServerPath('docker-langserver'),
  args: ["--stdio"]
}]

## go
lsp_servers += [{
  name: 'gopls',
  filetype: 'go',
  path: GetLspServerPath('gopls'),
  args: ['serve'],
  workspaceConfig: {
    gopls: {
      hints: {
        assignVariableTypes: v:true,
        compositeLiteralFields: v:true,
        compositeLiteralTypes: v:true,
        constantValues: v:true,
        functionTypeParameters: v:true,
        parameterNames: v:true,
        rangeVariableTypes: v:true
      }
    }
  }
}]

## html
lsp_servers += [{
  name: 'vscode-html-language-server',
  filetype: ['html'],
  path: GetLspServerPath("vscode-html-language-server"),
  args: ["--stdio"]
}]

lsp_servers += [{
  name: 'tailwindcss-language-server',
  filetype: ['html'],
  path: GetLspServerPath('tailwindcss-language-server'),
  args: ['--stdio'],
}]

## javascript / typescript
if v:true
  lsp_servers += [{
    name: 'vtsls',
    filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
    path: GetLspServerPath('vtsls'),
    args: ["--stdio"],
    debug: v:true,
    rootSearch: ['tsconfig.json', 'package.json', 'jsconfig.json', '.git'],
    # https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
    workspaceConfig: {
      vtsls: {
        autoUseWorkspaceTsdk: v:true
      },
      typescript: {
        inlayHints: {
          parameterNames: {
            enabled: 'all',
          },
          parameterTypes: {
            enabled: v:true,
          },
          variableTypes: {
            enabled: v:true,
          },
          propertyDeclarationTypes: {
            enabled: v:true,
          },
          functionLikeReturnTypes: {
            enabled: v:true,
          },
          enumMemberValues: {
            enabled: v:true,
          }
        }
      },
      javascript: {
        inlayHints: {
          parameterNames: {
            enabled: 'all',
          },
          parameterTypes: {
            enabled: v:true,
          },
          variableTypes: {
            enabled: v:true,
          },
          propertyDeclarationTypes: {
            enabled: v:true,
          },
          functionLikeReturnTypes: {
            enabled: v:true,
          },
          enumMemberValues: {
            enabled: v:true,
          }
        }
      }
    }
  }]
else
  lsp_servers += [{
    name: 'typescript-language-server',
    filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
    path: GetLspServerPath('typescript-language-server'),
    args: ["--stdio"],
    initializationOptions: {
      preferences: {
        includeInlayEnumMemberValueHints: v:true,
        includeInlayFunctionLikeReturnTypeHints: v:true,
        includeInlayFunctionParameterTypeHints: v:true,
        includeInlayParameterNameHints: 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName: v:true,
        includeInlayPropertyDeclarationTypeHints: v:true,
        includeInlayVariableTypeHints: v:true,
      }
    }
  }]
endif

lsp_servers += [{
  name: 'tailwindcss-language-server',
  filetype: ['javascriptreact', 'typescriptreact'],
  path: GetLspServerPath('tailwindcss-language-server'),
  args: ['--stdio']
}]

lsp_servers += [{
  name: 'biome-lsp',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'],
  path: GetLspServerPath('biome'),
  args: ['lsp-proxy'],
  runIfSearch: ['biome.json', 'biome.jsonc'],
}]

lsp_servers += [{
  name: 'vscode-eslint-language-server',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  path: GetLspServerPath('vscode-eslint-language-server'),
  args: ["--stdio"],
  runIfSearch: ['.eslint.config.js', '.eslint.config.mjs', '.eslint.config.cjs'],
}]

## json
var catalog_file = expand('~/.cache/schemastore/catalog.json')
var schemas = filereadable(catalog_file)
       \ ? readfile(catalog_file)->join()->json_decode()['schemas']
       \ : []

lsp_servers += [{
  name: 'vscode-json-language-server',
  filetype: ['json', 'jsonc'],
  path: GetLspServerPath("vscode-json-language-server"),
  args: ["--stdio"],
  initializationOptions: {
    provideFormatter: v:true
  },
  workspaceConfig: {
    json: {
      format: {
        enable: v:true
      },
      schemas: schemas
    }
  }
}]

## lua

lsp_servers += [{
  name: 'lua-language-server',
  filetype: ['lua'],
  path: exepath('lua-language-server'),
  workspaceConfig: {
    Lua: {
      color: {
        mode: 'Semantic'
      },
      completion: {
        callSnippet: 'Disable',
        enable: v:true,
        keywordSnippet: 'Replace'
      },
      develop: {
        debuggerPort: 11412,
        debuggerWait: v:false,
        enable: v:false
      },
      diagnostics: {
        enable: v:true,
        globals: '',
        severity: {}
      },
      hover: {
        enable: v:true,
        viewNumber: v:true,
        viewString: v:true,
        viewStringMax: 1000
      },
      runtime: {
        path: ['?.lua', '?/init.lua', '?/?.lua'],
        version: 'Lua 5.4'
      },
      signatureHelp: {
        enable: v:true
      },
      workspace: {
        ignoreDir: [],
        maxPreload: 1000,
        preloadFileSize: 100,
        useGitIgnore: v:true
      }
    }
  }
}]

## markdown
const marksman_bin = GetLspServerPath('marksman')
lsp_servers += [{
  name: 'marksman',
  filetype: ['markdown'],
  path: marksman_bin,
  args: ['server']
}]

if marksman_bin->empty()
  lsp_servers += [{
    name: 'vscode-markdown-language-server',
    filetype: ['markdown'],
    path: exepath('vscode-markdown-language-server'),
    args: ['--stdio']
  }]
endif

lsp_servers += [{
  name: 'obsidian-lsp',
  filetype: ['markdown'],
  path: GetLspServerPath('obsidian-lsp'),
  args: ["--stdio"],
  runIfSearch: ['.obsidian/']
}]

## powershell

lsp_servers += [{
  name: 'powershell-editor-services',
  filetype: ['ps1'],
  path: GetLspServerPath('~/.local/share/powershell-editor-services/powershell-editor-services'),
}]

## python
lsp_servers += [{
  name: 'pylsp',
  filetype: ['python'],
  path: GetLspServerPath('~/.local/share/python-lsp-server/pylsp'),
  args: [],
  workspaceConfig: {
    pylsp: {
      configurationSources: ['flake8'],
      plugins: {
        autopep8: { enabled: v:false },
        flake8: { enabled: v:true },
        mccabe: { enabled: v:false },
        pycodestyle: { enabled: v:false },
        pydocstyle: { enabled: v:false },
        pyflakes: { enabled: v:false },
        rope_autoimport: { enabled: v:true },
        rope_completion: { enabled: v:true },
        yapf: { enabled: v:false },
        ruff: { enabled: has('win32') ? v:true : v:false }
      }
    }
  },
  features: { 'codeAction': false }
}]

lsp_servers += [{
  name: 'pyright-langserver',
  filetype: ['python'],
  path: GetLspServerPath('pyright-langserver'),
  args: ["--stdio"],
  workspaceConfig: {
    python: {
      analysis: {
        autoImportCompletions: v:true,
        autoSearchPaths: v:true,
        reportMissingImports: true,
        typeCheckingMode: "strict",
        useLibraryCodeForTypes: v:true,
      }
    }
  },
  features: { 'codeAction': false }
}]

lsp_servers += [{
  name: 'ruff-lsp',
  filetype: ['python'],
  path: GetLspServerPath('ruff-lsp'),
  args: [],
  workspaceConfig: {
    settings: {
      run: 'onSave'
    }
  }
}]

## rust

lsp_servers += [{
  name: 'rust-analyzer',
  filetype: ['rust'],
  path: GetLspServerPath('rust-analyzer'),
  args: [],
  syncInit: v:true,
  workspaceConfig: {
    inlayHints: {
      bindingModeHints: {
        enable: v:false
      },
      closingBraceHints: {
        minLines: 10
      },
      closureReturnTypeHints: {
        enable: "with_block"
      },
      discriminantHints: {
        enable: "fieldless"
      },
      lifetimeElisionHints: {
        enable: "skip_trivial"
      },
      typeHints: {
        hideClosureInitialization: v:false
      }
    },
    check: {
      command: "clippy"
    },
    completion: {
      autoimport: { enable: v:true },
    },
  }
}]

## toml
lsp_servers += [{
  name: 'taplo-lsp',
  filetype: ['toml'],
  path: GetLspServerPath('taplo'),
  args: ['lsp', 'stdio']
}]

## vim
lsp_servers += [{
  name: 'vim-language-server',
  filetype: ['vim'],
  path: GetLspServerPath('vim-language-server'),
  args: ['--stdio'],
  initializationOptions: {
    isNeovim: v:false,
    vimruntime: $VIMRUNTIME,
    runtimepath: &runtimepath,
    iskeyword: &isk .. ',:',
    diagnostic: {enable: v:true},
    indexes: {
      runtimepath: v:true
    },
    suggest: {
      fromVimruntime: v:true,
      fromRuntimepath: v:true
    }
  }
}]

## yaml
def SchemasMap(): dict<list<string>>
  var result = {}
  for v in schemas
    if has_key(v, 'fileMatch')
      result[v['url']] = v['fileMatch']
    endif
  endfor
  return result
enddef

lsp_servers += [{
  name: 'yaml-language-server',
  filetype: ['yaml'],
  path: GetLspServerPath('yaml-language-server'),
  args: ['--stdio'],
  workspaceConfig: {
    yaml: {
      format: {
        enable: v:true
      },
      schemas: SchemasMap()
    }
  }
}]

## efm-langserver
lsp_servers += [{
  name: 'efm-langserver',
  filetype: ['css', 'dockerfile', 'fish', 'html', 'javascript', 'javascriptreact', 'json', 'go',
    'markdown', 'ps1', 'python', 'scss', 'sh', 'toml', 'typescript', 'typescriptreact', 'vim', 'vue', 'yaml'],
  path: GetLspServerPath('efm-langserver'),
  initializationOptions: {
    documentFormatting: v:true,
    hover: v:false,
    documentSymbol: v:true,
    codeAction: v:true,
    completion: v:true,
  },
}]

## typos-lsp
lsp_servers += [{
  name: 'typos-lsp',
  filetype: ['css', 'dockerfile', 'fish', 'html', 'javascript', 'javascriptreact', 'json', 'go',
    'markdown', 'ps1', 'python', 'scss', 'sh', 'toml', 'typescript', 'typescriptreact', 'vim', 'vue', 'yaml'],
  path: GetLspServerPath('typos-lsp'),
  initializationOptions: {
    diagnosticSeverity: "Info"
  }
}]

# initialize

def DisableDiag(condition: bool = true)
  if !condition
    return
  endif
  LspDiag highlight disable
enddef

def LspSetupBufferLocal()
  nnoremap <buffer> <Leader>s  <Cmd>LspDocumentSymbol<CR>
  nnoremap <buffer> <Leader>S  <Cmd>LspSymbolSearch<CR>
  nnoremap <buffer> <Leader>d  <Cmd>LspDiag show<CR>
  nnoremap <buffer> <Leader>a  <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <Leader>k  <Cmd>LspHover<CR>
  nnoremap <buffer> <Leader>r  <Cmd>LspRename<CR>
  nnoremap <buffer> <Leader>h  <Cmd>LspPeekReferences<CR>
  nnoremap <buffer> <Leader>H  <Cmd>LspShowReferences<CR>
  nnoremap <buffer> gy  <Cmd>LspGotoTypeDef<CR>
  nnoremap <buffer> gd  <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> gD  <Cmd>LspGotoDeclaration<CR>
  nnoremap <buffer> gI  <Cmd>LspGotoImpl<CR>

  nmap <buffer> [d  <Cmd>LspDiag prev<CR>
  nmap <buffer> ]d  <Cmd>LspDiag next<CR>
enddef

lsp_servers->filter((_, v) => !empty(v.path))
augroup vimrc_lsp_init
  autocmd!
  autocmd User LspAttached  LspSetupBufferLocal()
  # ファイルの先頭に "vim9script" があったら Diag を無効化する
  autocmd FileType vim  DisableDiag(getline(1, 5)->join()->match('^vim9script') > -1)
  autocmd BufReadPost *.tmpl  DisableDiag()
  autocmd VimEnter * ++once g:LspOptionsSet(lsp_options)
  autocmd VimEnter * ++once g:LspAddServer(lsp_servers)
augroup END
