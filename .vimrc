
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 •••••• Config Explanation ••••• 𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 •••••••• Basic Config ••••••••• 𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 •• No legacy vi compatibility   𐀏"
"𐀏 •• Display line numbers         𐀏"
"𐀏 •• Display invisibles           𐀏"
"𐀏 •• Enable syntax highlighting   𐀏"
"𐀏 •• Display incomplete commands  𐀏"
"𐀏 •• Use unnamed clipboard        𐀏"
"𐀏 •• Load filetype plugins        𐀏"
"𐀏 •• Always show ruler            𐀏"
"𐀏 •• Display completion matches   𐀏"
"𐀏 •• Text width is 79 chars       𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 •••••• Whitespace Config •••••• 𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 •• Do not wrap lines            𐀏"
"𐀏 •• Use spaces instead tabs      𐀏"
"𐀏 •• Display tabs as 2 spaces     𐀏"
"𐀏 •• Backspace everything in :i   𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
"𐀏 ••••••• Unused Config ••••••••••• 𐀏"
"𐀏≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈𐀏"
" filetype off
" set syntax=ON
" set nowrap
"
set syntax=on
set wildmenu
set ruler
set nocompatible
set number
set list
set encoding=utf-8
set showcmd
set clipboard=unnamed
set expandtab
set tabstop=2 shiftwidth=2
set backspace=indent,eol,start
set textwidth=79
set cursorline   " highlight current line
set cursorcolumn " highlight current column
set hlsearch     " highlight matches
set incsearch    " incremental searching
set ignorecase   " searches are case insensitive...
set smartcase    " ... unless they contain at least one capital letter

filetype plugin on
filetype plugin indent on

if has('mouse')
  set mouse=a
endif

command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
         \ | wincmd p | diffthis

set guifont=DejaVuSansMono:h20
set laststatus=2
set background=dark
"
"map Ctrl+n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>
map <C-Tab> :tabn<CR>
map <C-S-Tab> :tabp<CR>

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'https://github.com/bronson/vim-crosshairs'
Plugin 'altercation/solarized'
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
" Plugin 'Valloric/YouCompleteMe'
" YouCompleteMe requires more work for osx
" See https://github.com/Valloric/YouCompleteMe#installation

"Plugins must be added before the following line
call vundle#end()

" To ignore plugin indent changes, use 'filetype plugin on'

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:ackprg='ag --vimgrep' "use Ag with [ack.vim][]
let g:vim_markdown_preview_github=1
let g:vim_markdown_folding_disabled=1
let g:vim_json_syntax_conceal=0
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_contrast='normal'
let g:solarized_visibility='high'
let g:foldmethod='marker'
let NERDTreeShowHidden=1

colorscheme solarized
syntax enable

