command! -nargs=0 -bar Trim %substitute/\s\+$//e <bar> %substitute/\($\n\s*\)\+\%$//e

function s:TrimOnSave()
    if &ft == "markdown"
        return
    endif
    let backupRegA = getpos("'a")
    normal! ma
    keepjumps Trim
    " silent with bang in case the mark 'a' was on a blank line deleted at the
    " end of the file
    keepjumps silent! normal! `a
    call setpos("'a", backupRegA)
endfunction

augroup FormatOnSave
    autocmd!
    autocmd BufWritePre * call <SID>TrimOnSave()
augroup END
