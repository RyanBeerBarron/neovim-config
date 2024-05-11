inoremap <buffer> sout System.out.println
inoreabbrev <buffer> main public static void main(String[] args) {<cr>}<ESC>kA

inoremap <buffer> <C-x><C-n> <C-r>=<SID>className()<cr>

function s:className()
    return expand("%:t:r")
endfunction

setlocal wildignore+=*.class
setlocal wildignore+=*/target/*

setlocal colorcolumn=100
setlocal foldmethod=expr
setlocal foldexpr=s:foldJava(v\:lnum)
setlocal foldtext=s:foldText()
setlocal foldlevel=2

function s:foldJava(lnum)
    let line = getline(a:lnum)
    let foldlevel = FoldMarkers(line)
    if foldlevel > 0
        return foldlevel
    endif
    if line =~ '^import'
        return 3
    endif
    return nvim_treesitter#foldexpr()
endfunction

function s:foldText()
    let linenr = v:foldstart
    let line = getline(linenr)->trim()
    while line !~? '{{{$' && (line[0] == '@' || line[0:1] == '/*')
        let linenr += 1
        let line = getline(linenr)->trim()
    endwhile
    let line = line->substitute('{{{$', '', '')->substitute('^-\+ *', '', '')
    return FoldText(line, linenr, v:foldend, v:folddashes)
endfunction

nnoremap <buffer> <A-m> <cmd>ExecBuild<cr>
nnoremap <buffer> <A-S-t> <cmd>execute "ExecTest " . <SID>setTest()<cr>
nnoremap <buffer> <A-t> <cmd>execute "ExecTest " . <SID>getTest()<cr>

nnoremap <buffer> <A-o> <Cmd>lua require('jdtls').organize_imports()<CR>
nnoremap <buffer> crv <Cmd>lua require('jdtls').extract_variable()<CR>
vnoremap <buffer> crv <Cmd>lua require('jdtls').extract_variable(true)<CR>
nnoremap <buffer> crc <Cmd>lua require('jdtls').extract_constant()<CR>
vnoremap <buffer> crc <Cmd>lua require('jdtls').extract_constant(true)<CR>
vnoremap <buffer> crm <Cmd>lua require('jdtls').extract_method(true)<CR>

let s:test=""
function s:getTest()
    return s:test
endfunction

function s:setTest()
    let line = getline('.')
    let matches = matchlist(line, 'public void \(\w\+\)()')
    if matches[1] != ''
        let s:test = matches[1]
    else
        let s:test = expand("%:t:r")
    endif
    return s:test
endfunction
