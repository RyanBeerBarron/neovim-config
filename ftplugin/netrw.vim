nmap <buffer> h -
nmap <buffer> l <cr>
nmap <buffer> <nowait> <space> mfj

nnoremap <buffer> % <cmd>call <SID>NetrwCreateFile()<CR>

function s:NetrwCreateFile()
    let ykeep = @@
    call inputsave()
    let fname= input("Enter filename: ")
    call inputrestore()
    let fname = fnameescape(fname)
    if exists("t:netrw_lexbufnr")
        let lexwinnr = bufwinnr(t:netrw_lexbufnr)
        if lexwinnr != -1 && exists("g:netrw_chgwin") && g:netrw_chgwin != -1
            if exists("b:netrw_curdir")
                let fname = b:netrw_curdir .. "/" .. fname
                call writefile([], fname)
                exe "NetrwKeepj keepalt ".g:netrw_chgwin."wincmd w"
                exe "NetrwKeepj e ".. fname
            else
                echomsg "No b:netrw_curdir found"
            endif
            let @@= ykeep
        endif
    endif

    " Does the filename contain a path?
    if fname !~ '[/\\]'
        if exists("b:netrw_curdir")
            if exists("g:netrw_quiet")
                let netrw_quiet_keep = g:netrw_quiet
            endif
            let g:netrw_quiet = 1
            " save position for benefit of Rexplore
            let s:rexposn_{bufnr("%")}= winsaveview()
            "    call Decho("saving posn to s:rexposn_".bufnr("%")."<".string(s:rexposn_{bufnr("%")}).">",'~'.expand("<slnum>"))
            if b:netrw_curdir =~ '/$'
                exe "NetrwKeepj e ".fnameescape(b:netrw_curdir.fname)
            else
                exe "e ".fnameescape(b:netrw_curdir."/".fname)
            endif
            if exists("netrw_quiet_keep")
                let g:netrw_quiet= netrw_quiet_keep
            else
                unlet g:netrw_quiet
            endif
        endif
    else
        exe "NetrwKeepj e ".fnameescape(fname)
    endif
    let @@= ykeep
endfunction
