" CdBuffer: cd in buffer directory
command! -nargs=0 Cd cd %:h | echo "now in directory: " .. getcwd()
nnoremap <leader>cd <cmd>Cd<cr>

command! -nargs=1 MoveWin call <SID>moveWinToTab(<args>)
nnoremap <C-t>m <cmd>execute "MoveWin " .. v:count1<cr>

function! s:moveWinToTab(tabnum)
    let bufnr = bufnr()
    wincmd c
    execute "normal " .. a:tabnum .. "gt"
    execute "sbuffer " .. bufnr
endfunction
