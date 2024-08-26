command -bar -nargs=1 ConfigGrep call config#grep(<f-args>)
command -bar -nargs=? -complete=customlist,config#completion_config
            \ Config call config#open(<f-args>)

" Adding a <bar> at the end to preserve the trailing whitespace
nnoremap <leader>cf :Config |
nnoremap <leader>cg :ConfigGrep |
