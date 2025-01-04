inoremap <buffer> sout System.out.println
inoreabbrev <buffer> main public static void main(String[] args) {<cr>}<ESC>kA

inoremap <buffer> <C-x><C-n> <C-r>=<SID>className()<cr>

function s:className()
    return expand("%:t:r")
endfunction

setlocal colorcolumn=100
setlocal foldmethod=expr
setlocal foldexpr=s:foldJava(v\:lnum)
setlocal foldlevel=2
setlocal nolist

function s:foldJava(lnum)
    let line = getline(a:lnum)
    if line =~ '^import'
        return 3
    endif
    return v:lua.vim.treesitter.foldexpr()
endfunction

nnoremap <buffer> <A-m> <cmd>ExecBuild<cr>
nnoremap <buffer> <A-S-t> <cmd>execute "ExecTest " . <SID>setTest()<cr>
nnoremap <buffer> <A-t> <cmd>execute "ExecTest " . <SID>getTest()<cr>
nnoremap <buffer> [[  [m
nnoremap <buffer> []  [M
nnoremap <buffer> ][  ]m
nnoremap <buffer> ]]  ]M


let s:test=""
function s:getTest()
    return s:test
endfunction

function s:setTest()
    let line = getline('.')
    let matches = matchlist(line, 'public void \(\w\+\)()')
    if len(matches) > 0
        let s:test = matches[1]
    else
        let s:test = expand("%:t:r")
    endif
    return s:test
endfunction
