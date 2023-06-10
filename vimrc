
"""
""" Plugins
"""

call plug#begin('~/.vim/.plugged')

" Gruvbox
Plug 'morhetz/gruvbox'

Plug 'tpope/vim-sensible'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" LSP
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" 
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Rust
Plug 'rust-lang/rust.vim'

" CoC.nvim
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
" Plug 'junegunn/vim-easy-align'

" Multiple Plug commands can be written in a single line using | separators
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

call plug#end()


"""
""" Options
"""

set autoindent
set smartindent
set tabstop=8
set expandtab
set shiftwidth=4
set number
set relativenumber
set encoding=utf-8
set nobackup
set nowritebackup
set noshowmode
set updatetime=300
set signcolumn=yes
set cursorline
set scrolloff=5
set background=dark

" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"


"""
""" Colorscheme Config
"""

colorscheme slate


"""
""" Normal Keybindings
"""

let mapleader=' '

nnoremap J 5j
nnoremap K 5k

" Line head and end
nnoremap H ^
nnoremap L $

" Switch buffer
nnoremap ]b :bn<cr>
nnoremap [b :bp<cr>

" Close buffer
nnoremap <leader>c :bdelete<cr>

" Save and quit
nnoremap <leader>w :write<cr>
nnoremap <leader>q :quit<cr>

" Jump window
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>

" Change window size
nnoremap <C-Up> 5<C-w>+
nnoremap <C-Down> 5<C-w>-
nnoremap <C-Left> 5<C-w><
nnoremap <C-Right> 5<C-w>>

" File tree
nnoremap <leader>e <cmd>NERDTreeToggle<cr>
nnoremap <leader>o <cmd>NERDTreeFocus<cr>

" Plugin manager
nnoremap <leader>pi <cmd>PlugInstall<cr>
nnoremap <leader>pu <cmd>PlugUpdate<cr>
nnoremap <leader>pU <cmd>PlugUpgrade<cr>
nnoremap <leader>pc <cmd>PlugClean<cr>
nnoremap <leader>ps <cmd>PlugStatus<cr>


"""
""" LSP Config and Keybinds
"""
" if executable('rust-analyzer')
  " au User lsp_setup call lsp#register_server({
        " \   'name': 'Rust Language Server',
        " \   'cmd': {server_info->['rust-analyzer']},
        " \   'whitelist': ['rust'],
        " \   'initialization_options': {
        " \     'cargo': {
        " \       'buildScripts': {
        " \         'enable': v:true,
        " \       },
        " \     },
        " \     'procMacro': {
        " \       'enable': v:true,
        " \     },
        " \   },
        " \ })
" endif
" 
" " Diagnostic navigation
" nmap <silent> ]g  :LspNextDiagnostic<Cr>
" nmap <silent> [g  :LspPreviousDiagnostic<Cr>
" 
" " Code navigation
" nmap <silent> gd  :LspDefinition<Cr>
" nmap <silent> gy  :LspTypeDefinition<Cr>
" nmap <silent> gi  :LspImplementation<Cr>
" nmap <silent> gr  :LspReferences<Cr>
" 
" " Symbol renaming
" nmap <leader>lr  :LspRename<Cr>
" 
" " Code action for whole buffer
" nmap <leader>la  :LspCodeAction<Cr>
" 
" " Run the Code Lens action on the current line
" nmap <leader>ll  :LspCodeLens<Cr>


"""
""" FZF Config
"""

let $FZF_DEFAULT_COMMAND = "fd -tf --hidden --strip-cwd-prefix --exclude .git --exclude .cache --exclude .idea"
nmap <leader>ff :FZF<Cr>


"""
""" Airline Config
"""

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_nr_format = '%s: '
let g:airline#extensions#battery#enabled = 1
let g:airline_left_sep = ' '
let g:airline_left_alt_sep = '|'
