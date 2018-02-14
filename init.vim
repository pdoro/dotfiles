" ========================================================
" ================ NEOVIM CONFIGURATION ==================
" ========================================================

" ======================== PLUGINS =======================
call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'godlygeek/tabular'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'majutsushi/tagbar'

" Initialize plugin system
call plug#end()

" ====================== CONFIGURATION =====================

syntax on
colorscheme onedark

" ====================== PLUGIN CFG =====================

let g:airline_theme = 'wombat'
let g:airline_powerline_fonts = 1

" let g:deoplete#enable_at_startup = 1
let g:indent_guides_enable_on_vim_startup = 1

set showmatch           " Show matching brackets.
set number              " Show the line numbers on the left side.
set formatoptions+=o    " Continue comment marker in new lines.
set expandtab           " Insert spaces when TAB is pressed.
set tabstop=4           " Render TABs using this many spaces.
set shiftwidth=4        " Indentation amount for < and > commands.

set background=dark
hi IndentGuidesEven ctermbg=lightgrey

set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
    set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
    set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

" ====================== MAPPINGS =====================

nmap <F8> :TagbarToggle<CR>
