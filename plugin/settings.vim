"basic settings
set autowrite
set backupext=.bak
set cmdheight=1
set cmdwinheight=12
set completeopt=menu,menuone,popup
set concealcursor=
set conceallevel=0
set expandtab
set foldclose&
set foldcolumn=0
set foldexpr=FoldParagraphs(v\:lnum)
set foldlevel=2
set foldmethod=expr
set grepformat=%f:%l:%c:%m
set grepprg=git\ grep\ --line-number\ --column
set guifont=CaskaydiaCove\ Nerd\ Font:h16
"set guifont=IosevkaTerm\ Nerd\ Font:h16
set ignorecase
set inccommand=split
set incsearch
set linebreak
set listchars=tab:󰌒\ \ ,eol:↲,trail:.,extends:<,precedes:>,nbsp:␣
set matchtime=1
set modelineexpr
set nocursorcolumn
set nocursorline
set nolist
set nonumber
set nowrap
set path=,,**
set pumheight=10
set ruler
set scrolloff=8
set shiftwidth=4
set showmatch
set showmode
set signcolumn=no
set smartcase
set smartindent
set softtabstop=4
set spell
set spelllang=en,fr
set tabstop=4
set tildeop
set title
set undofile
set wildoptions=fuzzy,pum,tagfile

"netrw settings
let g:netrw_altfile=1
let g:netrw_banner=0
let g:netrw_liststyle=0
let g:netrw_keepj = 'keepj'

autocmd FileType lua,bash,sh,vim,json,go,javascript setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
autocmd BufReadPost *.bak execute "doautocmd BufReadPost " .. expand("<afile>:r")

" vim: foldlevel=0
colorscheme kanagawa
