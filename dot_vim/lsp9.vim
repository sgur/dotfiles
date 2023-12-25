vim9script

if &readonly || !&loadplugins
  finish
endif

try
  packadd! lsp
catch /^Vim\%((\a\+)\)\=:E919/
  echomsg v:errmsg
  finish
endtry

# options
#
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

def GetLspServerPath(name: string): string
  return expand(name)->exepath()
enddef

## astro
lsp_servers += [{
  name: 'astro-ls',
  filetype: ['astro'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "dlx", "@astrojs/language-server", "--stdio"]
}]

## bash
lsp_servers += [{
  name: 'bash-language-server',
  filetype: ['sh', 'bash'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "dlx", "bash-language-server", "start"]
}]

## css
lsp_servers += [{
  name: 'vscode-css-language-server',
  filetype: ['css', 'less', 'sass', 'scss'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent",  "--package=vscode-langservers-extracted", "dlx", "vscode-css-language-server", "--stdio"]
}]

lsp_servers += [{
  name: 'stylelint-lsp',
  filetype: ['css', 'less', 'sass', 'scss'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "--package=stylelint-lsp", "--package=stylelint-config-standard-scss", "dlx", "stylelint-lsp", "--stdio"]
}]

lsp_servers += [{
  name: 'tailwindcss-intellisense',
  filetype: ['css', 'html', 'javascriptreact', 'typescriptreact'],
  path: GetLspServerPath('~/.local/share/tailwindcss-intellisense/tailwindcss-intellisense'),
  args: ['--stdio'],
}]

## dockefile
lsp_servers += [{
  name: 'docker-langserver',
  filetype: ['dockerfile'],
  path: GetLspServerPath('pnpm'),
  args: ['--silent', 'dlx', 'dockerfile-language-server-nodejs', '--stdio']
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
  path: GetLspServerPath('pnpm'),
  args: ["--silent",  "--package=vscode-langservers-extracted", "dlx", "vscode-html-language-server", "--stdio"]
}]

## javascript / typescript
lsp_servers += [{
  name: 'typescript-language-server',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "dlx", "typescript-language-server", "--stdio"],
  initializationOptions: {
    preferences: {
      includeInlayParameterNameHintsWhenArgumentMatchesName: v:true,
      includeInlayParameterNameHints: 'all',
      includeInlayVariableTypeHints: v:true,
      includeInlayPropertyDeclarationTypeHints: v:true,
      includeInlayFunctionParameterTypeHints: v:true,
      includeInlayEnumMemberValueHints: v:true,
      includeInlayFunctionLikeReturnTypeHints: v:true
    }
  }
}]

lsp_servers += [{
  name: 'biome-lsp',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'],
  path: exepath('pnpm'),
  args: ['--silent', 'dlx', '@biomejs/biome', 'lsp-proxy', printf('--config-path="%s"', expand('~/.config/biome.json'))]
}]

lsp_servers += [{
  name: 'vscode-eslint-language-server',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent",  "--package=vscode-langservers-extracted", "dlx", "vscode-eslint-language-server", "--stdio"]
}]

## json
var catalog_file = expand('~/.cache/schemastore/catalog.json')
var schemas = filereadable(catalog_file)
       \ ? readfile(catalog_file)->join()->json_decode()['schemas']
       \ : []

lsp_servers += [{
  name: 'vscode-json-language-server',
  filetype: ['json'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent",  "--package=vscode-langservers-extracted", "dlx", "vscode-json-language-server", "--stdio"],
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
    path: exepath('pnpm'),
    args: ['--silent', '--package=vscode-langservers-extracted', 'dlx', 'vscode-markdown-language-server', '--stdio']
  }]
endif

lsp_servers += [{
  name: 'obsidian-lsp',
  filetype: ['markdown'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "dlx", "obsidian-lsp", "--stdio"],
  rootSearch: ['.obsidian/'],
  runIfSearch: ['.obsidian/']
}]

## powershell

lsp_servers += [{
  name: 'powershell-editor-services',
  filetype: ['powershell', 'ps1'],
  path: GetLspServerPath('~/.local/share/powershell-editor-services/powershell-editor-services'),
  args: []
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
      }
    }
  }
}]

lsp_servers += [{
  name: 'pyright-langserver',
  filetype: ['python'],
  path: GetLspServerPath('pnpm'),
  args: ["--silent", "--package=pyright", "dlx", "pyright-langserver", "--stdio"]
}]

lsp_servers += [{
  name: 'ruff-lsp',
  filetype: ['python'],
  path: GetLspServerPath('ruff-lsp'),
  args: [],
  workspaceConfig: {
    settings: {
      args: [],
      run: 'onSave'
    }
  }
}]

## toml
var taplo_lsp_options = {
  activationStatus: v:true,
  taploConfig: 'taplo://taplo.toml',
  taploConfigEnabled: v:true,
  semanticTokens: v:false,
  schema: {
    enabled: v:true,
    links: v:false,
    repositoryEnabled: v:true,
    repositoryUrl: 'https://taplo.tamasfe.dev/schema_index.json',
    associations: {
      '^(.*(/|\\)Cargo\.toml|Cargo\.toml)$': 'taplo://Cargo.toml',
    },
  },
  formatter: {
    alignEntries: v:false,
    alignComments: v:true,
    arrayTrailingComma: v:true,
    arrayAutoExpand: v:true,
    arrayAutoCollapse: v:true,
    compactArrays: v:true,
    compactInlineTables: v:false,
    compactEntries: v:false,
    columnWidth: 80,
    indentTables: v:false,
    indentEntries: v:false,
    indentString: v:null,
    reorderKeys: v:true,
    allowedBlankLines: 2,
    trailingNewline: v:true,
    crlf: v:false,
  },
  actions: {
    ignoreDepracatedAssociations: v:false
  },
  debug: v:false
}

lsp_servers += [{
  name: 'taplo-lsp',
  filetype: ['toml'],
  path: GetLspServerPath('taplo'),
  args: ['lsp', 'stdio'],
  initializationOptions: taplo_lsp_options,
  workspaceConfig: {
    evenBetterToml: taplo_lsp_options
  }
}]

## vim
lsp_servers += [{
  name: 'vim-language-server',
  filetype: ['vim'],
  path: GetLspServerPath('pnpm'),
  args: ['--silent', 'dlx', 'vim-language-server', '--stdio'],
  initializationOptions: {
    isNeovim: has('nvim'),
    vimruntime: $VIMRUNTIME,
    runtimepath: &rtp,
    iskeyword: &isk .. ',:',
    diagnostic: {enable: v:true}
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
  path: GetLspServerPath('pnpm'),
  args: ['--silent', 'dlx', 'yaml-language-server', '--stdio'],
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
    'markdown', 'ps1', 'python', 'scss', 'sh', 'typescript', 'typescriptreact', 'vim', 'vue', 'yaml'],
  path: GetLspServerPath('efm-langserver'),
  initializationOptions: {
    documentFormatting: v:true,
    hover: v:false,
    documentSymbol: v:true,
    codeAction: v:true,
    completion: v:true
  },
}]

# initialize

lsp_servers->filter((_, v) => !empty(v.path))
augroup vimrc_lsp_init
  autocmd!
  autocmd VimEnter * ++once g:LspOptionsSet(lsp_options) | g:LspAddServer(lsp_servers)
  # Multiple python LSP servers configured but only the first is running
  # https://github.com/yegappan/lsp/issues/384
  autocmd VimEnter * ++once if argc() > 0
    |   LspServer restart
    | endif
augroup END
