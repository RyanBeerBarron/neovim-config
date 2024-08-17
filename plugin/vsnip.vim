let g:vsnip_snippet_dir = $XDG_CONFIG_HOME .. '/vsnip'

imap <expr> <C-j> vsnip#expandable(i) ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
imap <expr> <C-l> vsnip#jumpable(-i) ? '<Plug>(vsnip-jump-prev)' : '<C-l>'

smap <expr> <C-j> vsnip#expandable(i) ? '<Plug>(vsnip-expand-or-jump)' : '<C-j>'
smap <expr> <C-l> vsnip#jumpable(-i) ? '<Plug>(vsnip-jump-prev)' : '<C-l>'
