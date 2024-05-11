setlocal foldmethod=expr
setlocal foldlevel=1
setlocal foldexpr=FoldLua(v\:lnum)
setlocal foldtext=s:foldText()

function FoldLua(lnum)
    let line = getline(a:lnum)
    let foldmarker = FoldMarkers(line)
    if foldmarker != v:null
        return foldmarker
    endif
    if line =~ '^\(local \)\?function \(\w\+\.\)\?\w\+(.*)$'
        return 1
    elseif line =~ '^\(local \)\?\(\w\+\.\)\?\w\+ = function(.*)$'
        return 1
    elseif line == 'end'
        return '<1'
    else
        let foldlevel = foldlevel(a:lnum -1)
        if foldlevel > 0
            return '='
        endif
    endif
    if line[:3] == '---@'
        return FoldLua(a:lnum+1)
    endif
    return '='
endfunction

function s:foldText()
    let linenr = v:foldstart
    let line = getline(linenr)
    while line[-3:-1] != '{{{$' && line[:2] == '--'
        let linenr += 1
        let line = getline(linenr)
    endwhile
    let line = line->substitute('{{{$', '', '')->substitute('^-\+ *', '', '')
    return FoldText(line, v:foldstart, v:foldend, v:folddashes)
endfunction
