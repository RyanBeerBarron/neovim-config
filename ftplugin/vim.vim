setlocal foldmethod=expr
setlocal foldexpr=s:foldVimscript(v\:lnum)
setlocal foldlevel=1

function s:foldVimscript(lnum)
    let line = getline(a:lnum)
    let foldlevel = FoldMarkers(line)
    if foldlevel > 0
        return foldlevel
    endif
    return nvim_treesitter#foldexpr()
endfunction
