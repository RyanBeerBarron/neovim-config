"basic settings
set autowrite
set backupext=.bak
set cmdheight=0
set cmdwinheight=12
set concealcursor=
set conceallevel=0
set expandtab
set foldclose&
set foldcolumn=0
set foldexpr=FoldParagraphs(v\:lnum)
set foldlevel=2
set foldmethod=expr
set grepprg=git\ grep\ --line-number
set grepformat=%f:%l:%m
set guifont=CaskaydiaCove\ Nerd\ Font:h16
"set guifont=IosevkaTerm\ Nerd\ Font:h16
set ignorecase
set incsearch
set linebreak
set list
set listchars=tab:󰌒\ \ ,eol:↲,trail:.,extends:<,precedes:>,nbsp:␣
set matchtime=1
set modelineexpr
set nocursorcolumn
set nocursorline
set nonumber
set noruler
set noshowmode
set nowrap
set path=,,**
set scrolloff=8
set shiftwidth=4
set showmatch
set signcolumn=no
set smartcase
set smartindent
set softtabstop=4
set spell
set spelllang=en,fr
set tabstop=4
set tildeop
set wildoptions=fuzzy,pum,tagfile

"netrw settings
let g:netrw_banner=0
let g:netrw_liststyle=0

autocmd FileType lua,bash,sh,c,vim,json,go setlocal foldexpr=nvim_treesitter#foldexpr()
autocmd BufReadPost *.bak execute "doautocmd BufReadPost " .. expand("<afile>:r")

" Global variables
let g:loaded_matchit = 1

" vim: foldlevel=0
colorscheme kanagawa
