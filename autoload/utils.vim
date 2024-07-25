function utils#is_prefix(string, prefix) abort
    return a:string[0:len(a:prefix)-1] ==? a:prefix
endfunction
