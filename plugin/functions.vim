" Function to serve as foldexpr for bash files with many functions
function! FoldBashFunction(lnum)
    let line = getline(a:lnum)
    if line[:7] == 'function'
       return 1
    endif
    if line[:0] == '}'
        return 's1'
    endif
    if line[:0] == '#'
        let result = FoldBashFunction(a:lnum+1)
        return result
    endif
    return '='
endfunction

function FoldCFunction(lnum)
    let line = getline(a:lnum)
    let nextline = getline(a:lnum + 1)
    if nextline[0] == '{'
        return 1
    endif
    if line[0] == '}'
        return 's1'
    endif
    if line[:1] == "//"
        let result = FoldCFunction(a:lnum+1)
        return result
    endif
    return '='
endfunction

function s:internal_recursive_fold_text(prefix, foldstart) abort
    let line = getline(a:foldstart)
    if utils#is_prefix(line, a:prefix)
        return s:internal_recursive_fold_text(a:prefix, a:foldstart+1)
    endif
    let count = v:foldend - v:foldstart
    return '+-' .. v:folddashes .. ' ' .. count .. ' lines: ' .. line
endfunction

function! RecursiveFoldText(prefix_to_ignore) abort
    return s:internal_recursive_fold_text(a:prefix_to_ignore, v:foldstart)
endfunction


function RunInTerm(arg = "")
    let cmd = a:arg
    if empty(cmd)
        let cmd = input("Command to run: ")
    endif
    if getenv('TMUX') != v:null
        call system('tmux split-window -v -l 33% ' .. cmd)
    else
        execute "botright " .. float2nr(floor(&lines * 0.33)) .. "split"
        execute "term " .. cmd
    endif
endfunction

function FoldParagraphs(lnum)
" Function to fold paragraph of texts
    let line = getline(a:lnum)
    return line =~ '\S'? 1 : '<1'
endfunction

function GetChar()
" Return the character on the cursor, or in front for insert mode
    let [_, _, col, _, _] = getcurpos()
    return getline('.')[col-1]
endfunction

function RGBtoBase10(rgb)
    let i = 0
    if a:rgb[0] == '#'
        let i = 1
    endif
    let red = str2nr(a:rgb[i:i+1], 16)
    let green = str2nr(a:rgb[i+2:i+3], 16)
    let blue = str2nr(a:rgb[i+4:i+5], 16)
    return red .. ", " .. green .. ", " .. blue
endfunction

function s:openFiles()
    let pattern = input("Open files: ")
    execute "arg **/*" .. pattern .. "*"
endfunction
nnoremap <C-x>f <cmd>call <SID>openFiles()<Cr>

function s:filterQuickfixList()
    let qflist = getqflist()
    let pattern = input("Filter Quickfix: ")
    let qflist = filter(qflist, {key,val -> <SID>matchPattern(key, val, pattern)})
    call setqflist(qflist)
endfunction

function s:matchPattern(qf_key, qf_val, pattern)
    let qf_text = a:qf_val.text
    let qf_filename = bufname(a:qf_val.bufnr)
    if a:pattern[0] == '!'
        return qf_text !~# a:pattern[1:] && qf_filename !~# a:pattern[1:]
    else
        return qf_text =~# a:pattern || qf_filename =~# a:pattern
    endif
endfunction

nnoremap <C-x>q <cmd>call <SID>filterQuickfixList()<Cr>

command! -nargs=? -range Dec2hex call s:Dec2hex(<line1>, <line2>, '<args>')
function s:Dec2hex(line1, line2, arg) range
  if empty(a:arg)
    if histget(':', -1) =~# "^'<,'>" && visualmode() !=# 'V'
      let cmd = 's/\%V\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    else
      let cmd = 's/\<\d\+\>/\=printf("0x%x",submatch(0)+0)/g'
    endif
    try
      execute a:line1 . ',' . a:line2 . cmd
    catch
      echo 'Error: No decimal number found'
    endtry
  else
    echo printf('%x', a:arg + 0)
  endif
endfunction

command! -nargs=? -range Hex2Dec call s:Hex2Dec(<line1>, <line2>, '<args>')
function s:Hex2Dec(line1, line2, arg) range
    if empty(a:arg)
        let cmd = 's/\<0x\x\+\>/\=printf("%d", submatch(0)+0)/g'
       try
           execute a:line1 . ',' . a:line2 . cmd
        catch
          echo 'Error: No decimal number found'
        endtry
    else
        echo printf('%d', a:arg + 0)
    endif
endfunction
