let s:first_line = getline(1)
if s:first_line =~? 'bash'
    set ft=bash
    finish
endif

nnoremap <buffer> <leader>f <cmd>%!sh<cr>
vnoremap <buffer> <leader>f :!sh<cr>
nnoremap <buffer> <leader>r <cmd>%w !sh<cr>
vnoremap <buffer> <leader>r :w !sh<cr>
