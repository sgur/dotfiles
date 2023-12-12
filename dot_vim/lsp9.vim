vim9script
packadd lsp

call LspOptionsSet({
  completionMatcher: 'fuzzy',
  diagSignErrorText: '😈',
  diagSignHintText: '💡',
  diagSignInfoText: '🗨️',
  diagSignWarningText: '🤔',
  echoSignature: v:true,
  omniComplete: v:true,
  showDiagWithVirtualText: has('patch-9.0.1157'),
  showInlayHints: has('patch-9.0.0178'),
  useBufferCompletion: v:true,
  vsnipSupport: v:true,
})

# Servers
# https://github.com/yegappan/lsp/wiki

var lsp_servers: list<dict<any>> = []

def GetLspServerPath(name: string): string
  return expand(name)->exepath()
enddef

## astro
lsp_servers += [{
  name: 'astro-ls',
  filetype: ['astro'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/astro-ls/astro-ls'),
  args: ['--stdio']
}]

## bash
lsp_servers += [{
  name: 'bash-language-server',
  filetype: ['sh', 'bash'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/bash-language-server/bash-language-server'),
  args: ['start']
}]

## css
lsp_servers += [{
  name: 'vscode-css-language-server',
  filetype: ['css', 'less', 'sass', 'scss'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/vscode-css-language-server/vscode-css-language-server'),
  args: ['--stdio'],
}]

lsp_servers += [{
  name: 'stylelint-lsp',
  filetype: ['css', 'less', 'sass', 'scss'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/stylelint-lsp/stylelint-lsp'),
  args: ['--stdio'],
}]

lsp_servers += [{
  name: 'tailwindcss-intellisense',
  filetype: ['css', 'html', 'javascriptreact', 'typescriptreact'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/tailwindcss-intellisense/tailwindcss-intellisense'),
  args: ['--stdio'],
}]

## dockefile
lsp_servers += [{
  name: 'docker-langserver',
  filetype: ['dockerfile'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/docker-langserver/docker-langserver'),
  args: ['--stdio'],
}]

## eslint
lsp_servers += [{
  name: 'vscode-eslint-language-server',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/vscode-eslint-language-server/vscode-eslint-language-server'),
  args: ['--stdio'],
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
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/vscode-html-language-server/vscode-html-language-server'),
  args: ['--stdio'],
}]

## javascript / typescript
lsp_servers += [{
  name: 'typescript-language-server',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/typescript-language-server/typescript-language-server'),
  args: ['--stdio'],
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

## json
var catalog_file = expand('~/.cache/schemastore/catalog.json')
var schemas = filereadable(catalog_file)
       \ ? readfile(catalog_file)->join()->json_decode()['schemas']
       \ : []

lsp_servers += [{
  name: 'vscode-json-language-server',
  filetype: ['json'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/vscode-json-language-server/vscode-json-language-server'),
  args: ['--stdio'],
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
const marksman_bin = GetLspServerPath('~/.local/share/vim-lsp-settings/servers/marksman/marksman')
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
    path: exepath('npx'),
    args: ['--yes', '--package=vscode-langservers-extracted', '--', 'vscode-markdown-language-server', '--stdio']
  }]
endif

lsp_servers += [{
  name: 'obsidian-lsp',
  filetype: ['markdown'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/obsidian-lsp/obsidian-lsp'),
  args: ['--stdio'],
  rootSearch: ['.obsidian/'],
  runIfSearch: ['.obsidian/']
}]

## python
lsp_servers += [{
  name: 'pylsp-all',
  filetype: ['python'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/pylsp-all/pylsp-all'),
  args: [],
  workspaceConfig: {
    pylsp: {
      configurationSources: ['flake8'],
      plugins: {
        autopep8: { enabled: v:false },
        mccabe: { enabled: v:false },
        pycodestyle: { enabled: v:false },
        pyflakes: { enabled: v:false },
        yapf: { enabled: v:false },
      }
    }
  }
}]

lsp_servers += [{
  name: 'pyright-langserver',
  filetype: ['python'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/pyright-langserver/pyright-langserver'),
  args: ['--stdio'],
}]

lsp_servers += [{
  name: 'ruff-lsp',
  filetype: ['python'],
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/ruff-lsp/ruff-lsp'),
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
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/taplo/taplo'),
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
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/vim-language-server/vim-language-server'),
  args: ['--stdio'],
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
  path: GetLspServerPath('~/.local/share/vim-lsp-settings/servers/yaml-language-server/yaml-language-server'),
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

# ## biome lsp-proxy
lsp_servers += [{
  name: 'biome-lsp',
  filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'],
  path: exepath('biome'),
  args: ['lsp-proxy', printf('--config-path="%s"', expand('~/.config/biome.json'))]
}]

# Initialize

g:LspAddServer(lsp_servers->filter((_, v) => !empty(v.path)))

# 1
