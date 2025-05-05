function log#error(...) abort
    let msg = a:000->join(' ')
    echohl Error | echomsg msg | echohl None
endfunction

function log#warn(...) abort
    let msg = a:000->join(' ')
    echohl WarningMsg | echomsg msg | echohl None
endfunction
