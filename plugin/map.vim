" Normal mode mappings
nnoremap q: <nop>
nnoremap <C-b> <nop>
nnoremap <S-j> j
nnoremap <M-,> <cmd>pop<cr>
nnoremap <M-.> <cmd>tag<cr>
nnoremap <C-x><C-x> <cmd>call RunInTerm()<cr>
nnoremap <space>rn :<cmd>call <SID>rename()<cr>

" I want all the brackets keymap to follow these rules:
" * The 1st bracket correspond to the direction,
"   ']' next or below in the file and '[' previous or above in the file
" * The 2nd bracket correspond to which curly bracket is looked for
"   ']' -> '}'      '[' -> '{'
" Swapping the following to get desired outcome
nnoremap ]] ][
nnoremap ][ ]]

function s:rename()
    let word = expand("<cword>")
    let prefix = "%s/\\<" .. word .. "\\>/"
    let suffix = "/g"
    let prefix_len = len(prefix)
    call setcmdline(prefix .. suffix, prefix_len+1)
endfunction

" Normal mode mappings with leader key
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>D "+D
nnoremap <leader>dd "+dd
nnoremap <leader>e <Cmd>Explore<CR>
if empty(maparg('\ws', 'n'))
    nnoremap <leader>ws <cmd>edit $XDG_DATA_HOME/workspace<cr>
endif

" Normal mode mappings for tab, to mimic Ctrl-w mapping for windows
nnoremap <C-t>n <cmd>tabnew<cr>
nnoremap <C-t>c <cmd>tabclose<cr>

" Insert mode mapping
inoremap {<cr> {<cr>}<ESC>O
imap <C-Space> <Nop>

" Visual mode mappings
vnoremap > >gv
vnoremap < <gv
vnoremap <S-j> j
vnoremap <S-k> k
vnoremap <leader>p "+p
vnoremap <leader>P "+P
vnoremap <leader>y "+y
vnoremap <leader>d "+d

cnoremap <C-x> <C-a>
