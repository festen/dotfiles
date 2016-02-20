" ---------------------- USABILITY CONFIGURATION ----------------------
"
"  Basic and pretty much needed settings to provide a solid base for
"  source code editting

" don't make vim compatible with vi
set nocompatible

" turn on syntax highlighting
syntax on

" make vim try to detect file types and load plugins for them
filetype on
filetype plugin on
filetype indent on

" reload files changed outside vim
set autoread

" encoding is utf 8
set encoding=utf-8
set fileencoding=utf-8

" enable matchit plugin which ships with vim and greatly enhances '%'
runtime macros/matchit.vim

" by default, in insert mode backspace won't delete over line breaks, or
" automatically-inserted indentation, let's change that
set backspace=indent,eol,start

" dont't unload buffers when they are abandoned, instead stay in the
" background
set hidden

" set unix line endings
set fileformat=unix
" when reading files try unix line endings then dos, also use unix for new
" buffers
set fileformats=unix,dos

" save up to 100 marks, enable capital marks
set viminfo='100,f1

" screen will not be redrawn while running macros, registers or other
" non-typed comments
set lazyredraw

" ---------------------- CUSTOMIZATION ----------------------
"  The following are some extra mappings/configs to enhance my personal
"  VIM experience

" set , as mapleader
let mapleader = ","

" map <leader>q and <leader>w to buffer prev/next buffer
noremap <leader>q :bp<CR>
noremap <leader>w :bn<CR>

" save with ctrl+s
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

" set default font
set guifont=Menlo\ for\ Powerline

" allow Tab and Shift+Tab to
" tab  selection in visual mode
vmap <Tab> >gv
vmap <S-Tab> <gv

" remove the .ext~ files, but not the swapfiles
set nobackup
set writebackup
set noswapfile

" search settings
set incsearch        " find the next match as we type the search
set hlsearch         " hilight searches by default
" use ESC to remove search higlight
"nnoremap <esc> :noh<return><esc>

" suggestion for normal mode commands
set wildmode=list:longest

" keep the cursor visible within 3 lines when scrolling
set scrolloff=3

" indentation
set expandtab       " use spaces instead of tabs
set autoindent      " autoindent based on line above, works most of the time
set smartindent     " smarter indent for C-like languages
set shiftwidth=4    " when reading, tabs are 4 spaces
set softtabstop=4   " in insert mode, tabs are 4 spaces

" no lines longer than 100 cols
set textwidth=100

" use <C-Space> for Vim's keyword autocomplete
"  ...in the terminal
inoremap <Nul> <C-n>
"  ...and in gui mode
inoremap <C-Space> <C-n>

" On file types...
"   .md files are markdown files
"autocmd BufNewFile,BufRead *.md setlocal ft=markdown
"   .twig files use html syntax
"autocmd BufNewFile,BufRead *.twig setlocal ft=html
"   .less files use less syntax
"autocmd BufNewFile,BufRead *.less setlocal ft=less
"   .jade files use jade syntax
"autocmd BufNewFile,BufRead *.jade setlocal ft=jade

" ---------------------- PLUGIN CONFIGURATION ----------------------
" initiate Vundle
let &runtimepath.=',$HOME/.vim/bundle/Vundle.vim'
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" start plugin defintion
"Plugin 'scrooloose/nerdtree'
"Plugin 'vim-scripts/L9'
"Plugin 'vim-scripts/FuzzyFinder'
"Plugin 'itchyny/lightline.vim'
"Plugin 'Lokaltog/vim-easymotion'
"Plugin 'tpope/vim-surround'
" -- Web Development
"Plugin 'Shutnik/jshint2.vim'
"Plugin 'mattn/emmet-vim'
"Plugin 'kchmck/vim-coffee-script'
"Plugin 'groenewege/vim-less'
"Plugin 'skammer/vim-css-color'
"Plugin 'hail2u/vim-css3-syntax'
"Plugin 'digitaltoad/vim-jade'

" end plugin definition
call vundle#end()            " required for vundle

" start NERDTree on start-up and focus active window
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

" map FuzzyFinder
"noremap <leader>b :FufBuffer<cr>
"noremap <leader>f :FufFile<cr>

" use zencoding with <C-E>
"let g:user_emmet_leader_key = '<c-e>'

" run JSHint when a file with .js extension is saved
" this requires the jsHint2 plugin
"autocmd BufWritePost *.js silent :JSHint

" set the color theme to wombat256
"colorscheme wombat256
" make a mark for column 100
set colorcolumn=100
" and set the mark color to DarkSlateGray
highlight ColorColumn ctermbg=lightgray guibg=lightgray
