" filetype detection with indenting
filetype plugin indent on

" must be before loading merlin below

call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips'
Plug 'aklt/plantuml-syntax'
Plug 'chriskempson/base16-vim'
Plug 'danro/rename.vim'
" Plug 'dense-analysis/ale'
Plug 'derekwyatt/vim-fswitch'
Plug 'fatih/vim-go'
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Plug '~/.opam/4.07.1/share/merlin', { 'for': ['ocaml', 'merlin' ], 'rtp': 'vim' }
call plug#end()

syntax enable
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set autowrite                  " auto-save current buffer when switching/making
set backspace=indent,eol,start " try to make deleting work not crazy
set directory=~/.vim/tmp//     " damn .swp files
set expandtab                  " soft tabs
set emoji                      " 😎
set nofoldenable
set foldmethod=manual          " syntax folding IS SO SLOW
set foldopen-=block            " block movement shouldn't open folds
set foldminlines=2             " don't fold a single line
set foldlevel=99               " start with no folding
set foldnestmax=1              " only 2 nested folds
set grepformat=%f:%l:%c:%m
set grepprg=rg\ --ignore\ log\ --column\ $*
set hidden                     " don't unload abandoned bufferes
set hlsearch                   " highlight search matches
set ignorecase                 " ignore case in patterns
set incsearch                  " incremental search
set linebreak                  " if wrapping, do it at whitespace
set list                       " show invisibles as per listchars
set listchars=eol:¬,tab:› ,nbsp:•
set modelines=2                " search top/bottom 2 lines for modelines
set nobackup                   " don't keep backup file
set noerrorbells               " turn off error bells
set number                     " show line numbers
" set omnifunc=ale#completion#OmniFunc " Use ALE's function for omnicompletion.
set ruler                      " show the cursor position in status bar
set scrolloff=5                " keep 5 lines of context around cursor
set shell=/bin/bash
set shiftwidth=2
set showcmd                    " show commands as they are typed
set showmatch                  " show matching () {} etc
set smartcase                  " don't ignorecase if there's a capital
set smarttab                   " try to get indenting correct
set splitbelow                 " split to the bottom, not top
set splitright                 " split to the right, not left
set tabstop=2
set updatetime=800
set visualbell                 " seriously no error bells
set wildmenu                   " better file menu

set completeopt=menu,menuone,preview " show menu and preview for autocomplete
" close preview when completion is done
augroup completion_preview_close
  autocmd!
  autocmd BufWritePost *.go if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
augroup END


autocmd BufWritePre * %s/\s\+$//e " Auto-strip trailing whitespace on write
" always show gutter column even if empty
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

let mapleader = ","
let maplocalleader = ","

" expand working directory inline
cmap %% <C-R>=expand('%:h').'/'<cr>
" sane movement over wrapped lines
nmap j gj
nmap k gk
vmap j gj
vmap k gk
" what does this even do normally?
nmap K <Nop>
" even the docs say Y is silly
nmap Y y$
" the best remap of all time
nmap <Leader><CR> :nohlsearch\|wa<CR><C-g>
" add a line before/after
nmap ]<Space> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nmap [<Space> :set paste<CR>m`O<Esc>``:set nopaste<CR>
" jump to previous/next in quicklist
nmap [q :cp<CR>
nmap ]q :cn<CR>
" jump to previous/next in quicklist
nmap [; :lp<CR>
nmap ]; :lne<CR>
" open quickfix
nmap <leader>co :cw 10<CR>
" close quickfix
nmap <leader>cc :cclose<CR>
" keep cursor position when shifting
nmap >> a<C-t><Esc>
nmap << a<C-d><Esc>
" quickly align =
nmap <Leader>= :Tab /=<CR>
" rebuild ctags
nmap <Leader>ct :!ctags -R .<CR>
" edit in cwd
nmap <Leader>e :e %%<C-D>
" switch current window to current file's cwd
map <leader>cd :lcd %:h<CR>
" quickly switch back to previous buffer
nmap <Leader><Leader> <C-^>
" I don't have time to figure out the difference
imap <C-c> <Esc>
" create a session and quit
nmap <leader>qq :mks! .vimsession\|wqa<CR>

" FZF.vim integrations
" fuzzzzzzzy find
nmap <leader><Space> :Files<CR>
" buffer management
nmap <leader>bl :Buffers<CR>
" close all buffers but current
nmap <leader>bd :%bd<CR><C-O>:bd#<CR>
" pop Ag
nmap <leader>a :Rg<CR>
" Ag for cword
nmap <leader>A :Rg <C-R>=expand("<cword>")<CR><CR>
" gs is a stupid mapping anyway
nmap gs :FSHere<CR>

function! UnhighlightMerlinIfDefined()
  if exists(":MerlinClearEnclosing")
    execute "MerlinClearEnclosing"
  endif
endfunction

autocmd FileType ocaml nmap <buffer> <Leader><CR> :nohlsearch\|wa<CR>:call UnhighlightMerlinIfDefined()<CR><C-g>
autocmd FileType ocaml nmap <buffer> gi :MerlinTypeOf<CR>
autocmd FileType ocaml nmap <buffer> <C-]> :MerlinLocate<CR>
autocmd BufEnter *.ml let b:fswitchdst = 'mli'| let b:fswitchlocs = '.'
autocmd BufEnter *.mli let b:fswitchdst = 'ml'| let b:fswitchlocs = '.'

let g:merlin_split_method = "never"
let g:merlin_locate_preference = 'ml'

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_set_highlights = 0
let g:ale_linters =
\ {'rust': ['rls']}
let g:ale_fixers =
\ {'rust': ['rustfmt'],
\  'ocaml':['ocamlformat'],
\  'javascript': ['prettier'],
\  'js': ['prettier'],
\  'html': ['prettier'],
\  'css': ['prettier'],
\  'scss': ['prettier']}

nmap <silent> [e <Plug>(ale_previous_wrap)
nmap <silent> ]e <Plug>(ale_next_wrap)

autocmd FileType rust nmap <C-[> <Plug>(ale_go_to_type_definition)
autocmd FileType rust nmap <C-]> <Plug>(ale_go_to_definition)
autocmd FileType rust nmap gi <Plug>(ale_hover)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" don't clobber <C-C> in sql files.
let g:ftplugin_sql_omni_key = '<C-S>'

let g:terraform_fmt_on_save = 1

" let g:go_gocode_propose_source = 0
" let g:go_gocode_propose_builtins = 1
" let g:go_gocode_unimported_packages = 1

let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_functions = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_types = 1
let g:go_auto_type_info = 1
let g:go_doc_popup_window = 1

let g:go_fmt_command = "gopls"
let g:go_fmt_autosave = 1
let g:go_fmt_options = { 'goimports': '-local github.com/honeycombio', }
let g:go_imports_mode = "goimports"
let g:go_imports_autosave = 1
let g:go_gopls_gofumt= v:true

let g:go_def_mode='gopls'
let g:go_info_mode = 'gopls'
let g:go_decls_mode='fzf'
let g:go_list_type = ""
" let g:go_debug = ['lsp']
let g:go_build_tags = ''

let g:go_metalinter_command = 'golangci-lint'
let g:go_metalinter_autosave = 0
" let g:go_metalinter_autosave_enabled = ['gofmt', 'vet', 'golint', 'errcheck', 'vetshadow']
let g:go_metalinter_deadline = "30s"

" set explicitly to empty, otherwise vim-go will try to use a bunch of default
" flags to golangci-lint. This will just use the defaults (and specifically,
" the config file by default)
let g:go_metalinter_enabled = []

let g:go_template_use_pkg = 1 " always use just package name in template

" SpellBad / SpellRare used for go errors/warnings also
highlight SpellBad  cterm=undercurl ctermfg=9 ctermbg=0
highlight SpellRare cterm=undercurl ctermfg=13 ctermbg=0

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips/']
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

autocmd BufNewFile,BufRead Dockerfile setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 foldmethod=syntax
autocmd FileType go nmap <LocalLeader>gT <Plug>(go-test-func)
autocmd FileType go nmap <LocalLeader>ga <Plug>(go-alternate-edit)
autocmd FileType go nmap <LocalLeader>gb :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <LocalLeader>gd <Plug>(go-decls-dir)
autocmd FileType go nmap <LocalLeader>gn <Plug>(go-info)
autocmd FileType go nmap <LocalLeader>ge <Plug>(go-err-check)
autocmd FileType go nmap <LocalLeader>gi <Plug>(go-imports)
autocmd FileType go nmap <LocalLeader>gl <Plug>(go-metalinter)
autocmd FileType go nmap <LocalLeader>gr <Plug>(go-run)
autocmd FileType go nmap <LocalLeader>gt <Plug>(go-test)
autocmd FileType go nmap <LocalLeader>gf :GoFillStruct<CR>
autocmd FileType go nmap <LocalLeader>gp :!pkill gopls<CR>
autocmd FileType go nmap <LocalLeader><C-]> <Plug>(go-def-tab)
" autocmd FileType go nmap <C-[> <Plug>(go-def-type)

silent! helptags ALL

