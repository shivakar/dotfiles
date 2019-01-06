" Initialize vim-plug
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
Plug 'Valloric/YouCompleteMe'
Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'godlygeek/tabular'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'scrooloose/syntastic'

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
