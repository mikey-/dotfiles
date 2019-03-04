set nocompatible                " choose no compatibility with legacy vi
set number                      " add line numbers
syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
set clipboard=unnamed
filetype off                    " required
"filetype plugin indent on       " load file type plugins + indentation

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set cursorline   " highlight current line
set cursorcolumn " highlight current column

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
let g:vim_json_syntax_conceal = 0
 
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
  
" let Vundle manage Vundle, required
"Plugin 'https://github.com/bronson/vim-crosshairs'
"altercation/solarized'
Plugin 'hashivim/vim-terraform'
Plugin 'gmarik/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'plasticboy/vim-markdown'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-airline/vim-airline'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'jisaacks/GitGutter'
Plugin 'tpope/vim-fugitive'
Plugin 'Raimondi/delimitMate'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'elzr/vim-json'
Plugin 'rizzatti/dash.vim'
Plugin 'JamshedVesuna/vim-markdown-preview'
"Plugin 'Valloric/YouCompleteMe' 
"YouCompleteMe requires more work for osx (https://github.com/Valloric/YouCompleteMe#installation)

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
let vim_markdown_preview_github=1
let g:solarized_termcolors=256
syntax enable
set guifont=DejaVuSansMono:h17
set background=dark
colorscheme solarized
set laststatus=2

let g:vim_markdown_folding_disabled = 1

"map Ctrl+n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>
map <C-Tab> :tabn<CR>
map <C-S-Tab> :tabp<CR>

let g:ackprg = 'ag --vimgrep' "use Ag with [ack.vim][]
