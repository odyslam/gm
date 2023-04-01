" .vimrc
"
" Tabs and Spaces
set tabstop=4
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start
set expandtab
set autoindent
set cindent
set smarttab

" Misc
"
" Hubrid line numbers: https://jeffkreeftmeijer.com/vim-number/
set number relativenumber
set nu rnu
set ruler
set showmatch
set wildmenu
set wildmode=full
set wrap
set linebreak
set hidden
set modeline
set hlsearch
set incsearch
set autoread                        " Auto-reload modified files (with no local changes)
set ignorecase                      " Ignore case in search
set smartcase                       " Override ignorecase if uppercase is used in search string
set report=0                        " Report all changes
set laststatus=2                    " Always show status-line
set scrolloff=4
set timeoutlen=200                  " Set timeout between key sequences
set background=dark
set mouse=a                         " Enable mouse in all modes
set wmh=0                           " Minimum window height = 0
set showcmd
set updatetime=250                  " How long before 'CursorHold' event
set nobackup
set nowritebackup
set noswapfile
set nostartofline
set foldlevel=99                    " Open all folds by default
set cmdheight=1
set matchtime=2                     " Shorter brace match time
set virtualedit=block
set tags+=.tags
set tags+=codex.tags
set undofile
set gdefault                        " Always use /g with %s/
set list
set listchars=tab:·\ ,eol:¬,trail:█
set fillchars=diff:\ ,vert:│
set diffopt=filler,vertical,foldcolumn:0
set statusline=%<%f\ (%{gitbranch#name()})\ %h%m%r%=%y\ \ %-14(%{&sw}:%{&sts}:%{&ts}%)%-14.(%l,%c%V%)\ %P
set spelllang=en_us,en_gb
set completeopt=menu
set foldmethod=syntax
set termguicolors

let g:asyncrun_open = 6


" We don't use tabs much, but at least try and show less cruft
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)

    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . (!empty(bufname) ? fnamemodify(bufname, ':t') : '[No Name]') . ' '
  endfor
  return s
endfunction
set tabline=%!Tabline()

if !has("nvim")
  set nocompatible                  " Don't try to be compatible with vi
  set ttyfast
  set t_Co=256
endif

let mapleader = "\<Space>"

let g:signify_vcs_list = ['git']

" Markdown
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_no_default_key_mappings = 1

" Latex
let g:vimtex_quickfix_mode = 0


" inccommand
if has("nvim")
  set inccommand=nosplit
endif

" Save on focus lost
au FocusLost * call s:SaveOnFocusLost()
function! s:SaveOnFocusLost()
  if !empty(expand('%:p')) && &modified
    write
  endif
endfunction

" Per file-type indentation
au FileType haskell     setlocal number sts=4 sw=4 expandtab formatprg=stylish-haskell
au FileType javascript  setlocal number sts=2 sw=2 expandtab nowrap
au FileType typescript  setlocal number sts=2 sw=2 expandtab nowrap
au FileType svelte      setlocal number sts=2 sw=2 expandtab nowrap
au FileType css         setlocal number ts=2  sw=2 noexpandtab nowrap
au FileType go          setlocal number ts=4  sw=4 noexpandtab
au FileType c,cpp,glsl  setlocal number ts=8  sw=8 noexpandtab
au FileType lua         setlocal number       sw=2 expandtab
au FileType sh,zsh      setlocal number sts=2 sw=2 expandtab
au FileType vim,ruby    setlocal number sts=2 sw=2 expandtab
au FileType help        setlocal number ts=4  sw=4 noexpandtab
au FileType solidity    setlocal number ts=4  sw=4 expandtab nowrap colorcolumn=120 textwidth=120 signcolumn=yes
au FileType graphql     setlocal number ts=4  sw=4 expandtab nowrap
au FileType rust        setlocal number signcolumn=yes nowrap colorcolumn=100 textwidth=100
au FileType plain       setlocal nonumber noai nocin nosi inde= wrap linebreak textwidth=80
au FileType pandoc      setlocal nonumber
au FileType markdown    setlocal nonumber conceallevel=2
au FileType rst         setlocal nonumber sw=2 expandtab wrap linebreak textwidth=80
au FileType fountain    setlocal nonumber noai nocin nosi inde= wrap linebreak
au FileType tex         setlocal

au BufRead,BufNewFile *.md        setf markdown
au BufRead,BufNewFile *.tex       setf tex
au BufRead,BufNewFile *.todo      setf todo
au BufRead,BufNewFile *.tikz      setf tex
au BufRead,BufNewFile *.toml      setf toml
au BufRead,BufNewFile *.rs        setf rust
au BufRead,BufNewFile *.mustache  setf mustache
au BufRead,BufNewFile *.tera      setf htmldjango
au BufRead,BufNewFile *.svelte    setf svelte

" If no file-type is detected, set to plain.
autocmd BufEnter * if &filetype == "" | setlocal ft=plain | endif

let c_no_curly_error = 1

if has("nvim")
  au TermOpen * set nonumber modifiable
endif

" Remove trailing whitespace on save
autocmd BufWritePre * call s:StripTrailing()
function! s:StripTrailing()
  if &ft =~ 'rust'
    return
  endif

  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

" Markdown, highlight YAML frontmatter
let g:vim_markdown_frontmatter = 1

" We use a POSIX shell
let g:is_posix = 1

" File-type
filetype on
filetype plugin on
filetype indent on

nnoremap <Space> <NOP>
nnoremap Q       <NOP>

" Make `Y` behave like `D` and `C`
nnoremap Y       y$

" Copy selected text to clipboard
xnoremap Y       :w !pbcopy

" Paste form clipboard
noremap PP       :r !pbpaste

" Easy command mode switch
inoremap kj <Esc>
inoremap <C-l> <C-x><C-l>

" Correct spelling mistakes
inoremap <C-s> <c-g>u<Esc>[s1z=`]a<c-g>

" Jump to high/low and scroll
noremap <C-k> H{
noremap <C-j> L}
" Move easily between ^ and $
noremap <C-h> ^
noremap <C-l> $
noremap j gj
noremap k gk


" Add headers

noremap <Leader>h .! headers

nnoremap <C-n>           *N
nnoremap <C-p>           #N
nnoremap c*              *Ncgn

nnoremap <Leader>n      :cnext<CR>
nnoremap <Leader>p      :cprev<CR>

autocmd BufRead fugitive\:* xnoremap <buffer> dp :diffput<CR>
autocmd BufRead fugitive\:* xnoremap <buffer> do :diffget<CR>

" Support jsonc comments in json files
autocmd FileType json syntax match Comment +\/\/.\+$+

 " Select recently pasted text
nnoremap <leader>v       V`]
" Switch buffers easily
nnoremap <Tab>   <C-^>

" Switch between .c and .h files easily
autocmd BufRead,BufNewFile *.c,*.h nnoremap <silent> <S-Tab> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>

" Switch between .cc and .h files easily
autocmd BufRead,BufNewFile *.cc,*.h nnoremap <silent> <S-Tab> :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" Actually easier to type and I do it by mistake anyway
cnoreabbrev W w
cnoreabbrev Q q

" Nerdtree toggle
nnoremap <C-t> :NERDTreeToggle<CR>


" Navigate relative to the current file
cmap     %/         %:p:h/

map <Leader>m       :make<CR>
map <Leader>e       :e ~/.vimrc<CR>
map <Leader>s       :source ~/.vimrc<CR>

" Repeat previous command
map <Leader><Space> @:

" Commenting
nmap <C-_>           <Plug>CommentaryLine
xmap <C-_>           <Plug>Commentary

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif

if executable('rg')
  let g:ackprg = 'rg -F -S --no-heading --vimgrep'
  set grepprg=rg\ -S\ -F\ --no-heading\ --vimgrep\ $*
endif

" Syntax coloring
syntax enable

filetype plugin on
set ofu=syntaxcomplete#Complete
highlight Pmenu guibg=brown gui=bold
highlight CocErrorHighlight ctermfg=Red  guifg=#ff0000

" Profiling
command! ProfileStart call s:ProfileStart()
function! s:ProfileStart()
  profile start profile
  profile func *
  profile file *
endfunction

command! ProfileStop call s:ProfileStop()
function! s:ProfileStop()
  profile stop
  tabnew profile
endfunction

" Get highlight group under cursor
command! Syn call s:Syn()
function! s:Syn()
  echo synIDattr(synID(line("."), col("."), 1), "name")
endfunction

if has("nvim")
  call plug#begin()
  Plug 'ekalinin/Dockerfile.vim'
  Plug  'preservim/nerdtree'
  Plug 'tpope/vim-commentary'
  Plug 'gabrielelana/vim-markdown'
  Plug 'junegunn/goyo.vim'
  Plug 'lervag/vimtex', { 'for': ['tex'] }
  Plug 'itchyny/vim-gitbranch'
  Plug 'neoclide/coc.nvim', { 'branch': 'release'}
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'github/copilot.vim'
  call plug#end()
endif

lua << EOF
require('gitsigns').setup {
  signs = {
    changedelete = { text = "│" }
  }
}
EOF

lua << EOF
require("telescope").setup({
  extensions = {
    coc = {
        theme = 'ivy',
        prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
    }
  },
})
require('telescope').load_extension('coc')
EOF
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
"
" Quickfix Signs
"
sign define quickfix-error text=× texthl=ErrorSign

command! QuickfixSigns call s:QuickfixSigns()

" autocmd BufWrite * sign unplace *
autocmd CursorHold *.rs silent QuickfixSigns

function! s:QuickfixSigns()
  silent! cgetfile
  sign unplace *
  for dict in getqflist()
    if dict.type != 'E'
      continue
    endif
    try
      silent exe "sign"
          \ "place"
          \ dict.lnum
          \ "line=" . string(dict.lnum)
          \ "name=" . "quickfix-error"
          \ "file=" . bufname(dict.bufnr)
    catch

    endtry
  endfor
endfunction


command! Write setlocal spell   | Goyo 100x98%
command! Code  setlocal nospell | Goyo!

" Delete the current file.
command! Delete call delete(expand('%')) | bdelete!

if has("nvim")
  " Make sure we dont' load the rust cargo plugin from rust.vim!
  let g:loaded_rust_vim_plugin_cargo = 1
  " Don't add errors to quickfix if rustfmt fails.
  let g:rustfmt_fail_silently = 1
endif

" coc.vim
function! SetupCoc()
  nmap <silent> gd           <Plug>(coc-definition)
  nmap <silent> gy           <Plug>(coc-type-definition)
  nmap <silent> gi           <Plug>(coc-implementation)
  nmap <silent> gr           <Plug>(coc-references)
  nmap <silent> gj           <Plug>(coc-diagnostic-next)
  nmap <silent> gk           <Plug>(coc-diagnostic-prev)
  nmap <silent> <leader>/    :CocList --interactive symbols<CR>
  nmap <silent> <leader>r    <Plug>(coc-rename)

  " This is a kind of hack to make <C-Y> not trigger snippet expansion.
  " We use <C-p><C-n> to insert the selection without triggering anything, and
  " then close the popup.
  inoremap <silent><expr> <C-Y> pumvisible() ? "<C-p><C-n><Esc>a" : "\<C-Y>"
  " Trigger completion on <CR>.
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endfunction
  autocmd User CocNvimInit call SetupCoc()
autocmd VimEnter * NERDTree | wincmd p


hi Pmenu guibg=#fffff gui=NONE
hi PmenuSel guibg=#b7c7b7 gui=NONE
hi PmenuSbar guibg=#bcbcbc
hi PmenuThumb guibg=#585858
