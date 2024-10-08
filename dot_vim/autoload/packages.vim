scriptencoding utf-8

" spell-checker: disable

packadd minpac

" Interface {{{1

function! packages#update() abort
  call s:init()
  call minpac#update()
endfunction

function! packages#clean() abort
  call s:init()
  call minpac#clean()
endfunction

function! packages#install() abort
  call s:init()
  const targets = minpac#getpluglist()->values()->filter({k,v -> !isdirectory(v.dir)})->map({k,v -> v.name})
  call minpac#update(targets)
endfunction


" Internal {{{1

function! s:nproc() abort
  return str2nr(
        \ has('win32')
        \ ? $NUMBER_OF_PROCESSORS
        \ : executable('nproc')
        \   ? systemlist('nproc')[0]
        \   : executable('sysctl')
        \     ? systemlist('sysctl -n hw.ncpu')[0]
        \     : 8)

  " macOS : sysctl -n machdep.cpu.cores_per_pacakge でもよさそう
endfunction


" Initialization {{{1

" verbose:
" - 2: Show error messages from external commands.
function! s:init() abort "{{{
  call minpac#init(#{
        \ jobs: s:nproc(),
        \ verbose: 3,
        \ })

  " Self-made {{{2

  call minpac#add('sgur/vim-textobj-parameter', #{
        \ type: 'opt',
        \ depth: 9999
        \ })

  " Generic {{{2
  "
  call minpac#add('LunarWatcher/auto-pairs', #{
        \ type: 'opt'
        \ })

  call minpac#add('girishji/vimcomplete', #{
        \ type: 'opt'
        \ })

  call minpac#add('girishji/scope.vim', #{
        \ type: 'opt'
        \ })

  call minpac#add('machakann/vim-sandwich', #{
        \ type: 'opt'
        \ })

  call minpac#add('editorconfig/editorconfig-vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('github/copilot.vim', #{
        \ type: 'opt'
        \ })

  call minpac#add('andymass/vim-matchup', #{
        \ type: 'opt'
        \ })

  call minpac#add('mattn/vim-molder', #{
        \ type: 'opt'
        \ })

  call minpac#add('itchyny/lightline.vim', #{
        \ type: 'opt'
        \ })

  call minpac#add('mattn/webapi-vim')

  call minpac#add('tpope/vim-repeat')

  call minpac#add('vim-jp/autofmt', #{
        \ type: 'opt'
        \ })

  call minpac#add('vim-jp/vimdoc-ja', #{
        \ pullmethod: 'autostash'
        \ })

  call minpac#add('kana/vim-operator-replace', #{
        \ type: 'opt'
        \ })

  call minpac#add('kana/vim-operator-user')

  call minpac#add('tpope/vim-commentary', #{
        \ type: 'opt'
        \ })

  call minpac#add('kana/vim-textobj-user')

  call minpac#add('mattn/vim-textobj-url', #{
        \ type: 'opt'
        \ })

  call minpac#add('airblade/vim-gitgutter', #{
        \ type: 'opt'
        \ })

  call minpac#add('haya14busa/vim-asterisk', #{
        \ type: 'opt'
        \ })

  call minpac#add('mbbill/undotree', #{
        \ type: 'opt'
        \ })

  call minpac#add('thinca/vim-prettyprint', #{
        \ type: 'opt'
        \ })

  " Colorscheme {{{2

  call minpac#add('catppuccin/vim', #{
        \ name: 'catppuccin',
        \ type: 'opt',
        \ })

  call minpac#add('cocopon/iceberg.vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('ghifarit53/tokyonight-vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('ajlende/atlas.vim', #{
        \ type: 'opt',
        \ })

  " Filetype {{{2

  call minpac#add('alker0/chezmoi.vim')

  call minpac#add('ap/vim-css-color')

  call minpac#add('AndrewRadev/tagalong.vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('hrsh7th/vim-vsnip', #{
        \ type: 'opt',
        \ })

  call minpac#add('hrsh7th/vim-vsnip-integ', #{
        \ type: 'opt',
        \ })

  call minpac#add('mattn/vim-sonictemplate', #{
        \ type: 'opt',
        \ })

  " Syntax {{{2

  call minpac#add('fourjay/vim-hurl')

  call minpac#add('imsnif/kdl.vim')

  call minpac#add('sheerun/vim-polyglot')

  call minpac#add('hail2u/vim-css3-syntax')

  call minpac#add('tyru/skkdict.vim')

  call minpac#add('rhysd/vim-gfm-syntax')

  " Omnifunc, etc. {{{2

  call minpac#add('vim-jp/vital.vim', #{
        \ type: 'opt',
        \ })

  " Lsp {{{2

  call minpac#add('yegappan/lsp', #{
        \ type: 'opt',
        \ })

  call minpac#add('mattn/vim-lsp-settings', #{
        \ type: 'opt',
        \ })

  call minpac#add('prabirshrestha/vim-lsp', #{
        \ type: 'opt',
        \ })

  call minpac#add('prabirshrestha/asyncomplete.vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('prabirshrestha/asyncomplete-lsp.vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('prabirshrestha/asyncomplete-buffer.vim', #{
        \ type: 'opt',
        \ })

  call minpac#add('prabirshrestha/asyncomplete-file.vim', #{
        \ type: 'opt',
        \ })
  " 2}}}
endfunction "}}}


" 1}}}
