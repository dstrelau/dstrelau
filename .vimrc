" filetype detection with indenting
filetype plugin indent on

call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips'
Plug 'aklt/plantuml-syntax'
Plug 'altercation/vim-colors-solarized'
Plug 'buoto/gotests-vim'
Plug 'chriskempson/base16-vim'
Plug 'danro/rename.vim'
Plug 'fatih/vim-go'
Plug 'godlygeek/tabular'
Plug 'hail2u/vim-css3-syntax'
Plug 'hashivim/vim-terraform'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-textobj-user'
Plug 'mtscout6/vim-cjsx'
Plug 'mxw/vim-jsx'
Plug 'othree/es.next.syntax.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'othree/yajs.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
call plug#end()

syntax enable
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

set autowrite                  " auto-save current buffer when switching/making
set backspace=indent,eol,start " try to make deleting work not crazy
set completeopt=menu,menuone   " no preview window for completions
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
set grepprg=ag\ --ignore\ log\ --column\ $*
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
set ruler                      " show the cursor position in status bar
set scrolloff=5                " keep 5 lines of context around cursor
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

autocmd BufWritePre * %s/\s\+$//e " Auto-strip trailing whitespace on write
" always show gutter column even if empty
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

let mapleader = ","

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
nmap <leader>e :edit %%
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
nmap <leader>a :Ag<CR>
" Ag for cword
nmap <leader>A :Ag <C-R>=expand("<cword>")<CR><CR>

" use preview window for :Ag
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%'),
  \                 <bang>0)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

let g:terraform_fmt_on_save = 1

let g:go_updatetime = 400
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_experimental = 1
let g:go_gocode_unimported_packages = 1
let g:go_list_type = ""
let g:go_metalinter_autosave = 0
let g:go_metalinter_autosave_enabled = ['gofmt', 'vet', 'golint', 'errcheck', 'vetshadow']
let g:go_metalinter_deadline = "30s"
let g:go_metalinter_enabled = ['gofmt', 'vet', 'golint', 'errcheck', 'vetshadow', 'unused']
let g:go_template_use_pkg = 1 " always use just package name in template
let g:go_build_tags = 'unit integration'

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips/']
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

autocmd BufNewFile,BufRead Dockerfile setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4 foldmethod=syntax
autocmd FileType go nmap <Leader>gT <Plug>(go-test-func)
autocmd FileType go nmap <Leader>ga <Plug>(go-alternate-edit)
autocmd FileType go nmap <Leader>gb :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
autocmd FileType go nmap <Leader>ge <Plug>(go-err-check)
autocmd FileType go nmap <Leader>gi <Plug>(go-imports)
autocmd FileType go nmap <Leader>gl <Plug>(go-metalinter)
autocmd FileType go nmap <Leader>gn <Plug>(go-info)
autocmd FileType go nmap <Leader>gr <Plug>(go-run)
autocmd FileType go nmap <Leader>gt <Plug>(go-test)
autocmd FileType go nmap <Leader>gf :GoFillStruct<CR>
autocmd FileType go nmap <Leader><C-]> <Plug>(go-def-tab)

autocmd BufWinEnter * if &buftype == 'terminal' | setlocal nowrap | endif
