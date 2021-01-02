"Initialize vim-plug
call plug#begin('~/.vim/plugins')

" Plugins
"" Color schemes
Plug 'notpratheek/vim-luna'

"" General writing
Plug 'MattesGroeger/vim-bookmarks'
Plug 'ntpeters/vim-better-whitespace'
Plug 'zeke/moby'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-wordy'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-notes'

"" Navigation
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'

"" Programming
Plug 'SirVer/ultisnips'
Plug 'ycm-core/YouCompleteMe'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'godlygeek/tabular'
Plug 'honza/vim-snippets'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'rust-lang/rust.vim'

"" Language specific
Plug 'fatih/vim-go'
Plug 'rhysd/vim-go-impl'
Plug 'sheerun/vim-polyglot'
Plug 'ap/vim-css-color'
Plug 'justmao945/vim-clang'
Plug 'vim-scripts/dbext.vim'

"" Display
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

filetype plugin indent on
call plug#end()
