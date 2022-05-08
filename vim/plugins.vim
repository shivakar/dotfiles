"Initialize vim-plug
call plug#begin('~/.vim/plugins')

" Plugins
"" Color schemes
Plug 'notpratheek/vim-luna'

"" General writing
Plug 'ntpeters/vim-better-whitespace'

"" Navigation
Plug 'preservim/nerdtree'
Plug 'easymotion/vim-easymotion'

"" Programming
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ycm-core/YouCompleteMe'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'

"" Language specific
Plug 'fatih/vim-go'
Plug 'rhysd/vim-go-impl'
Plug 'sheerun/vim-polyglot'
Plug 'ap/vim-css-color'

"" Display
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

filetype plugin indent on
call plug#end()
