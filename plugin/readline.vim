let s:CmdRegister = ""
let s:InsertRegister = ""

function! s:CmdKillWord()
    let cmdline = getcmdline()
    let cmd_len = strlen(cmdline)
    let index = getcmdpos()-1
    let startindex = index
    while index < cmd_len && cmdline[index] !~ '\k'
        let index += 1
    endwhile
    while index < cmd_len && cmdline[index] =~ '\k'
        let index += 1
    endwhile
    let cmd = cmdline[index:-1]
    if startindex != 0
        let cmd = cmdline[0:startindex-1] .. cmd
    endif
    let deleted = cmdline[startindex:index-1]
    if strlen(deleted) != 0
        let s:CmdRegister = deleted
    endif
    call setcmdline(cmd, getcmdpos())
endfunction

function! s:CmdBackwardKillWord()
    let cmdline = getcmdline()
    let cmd_len = strlen(cmdline)
    let index = getcmdpos()-1
    let startindex = index
    " We do 'index-1' because we look behind the cursor position
    " For the string, "as*df" where '*' is the cursor position
    " The cursor is on the 3rd column, so the index is at 2, i.e. on 'd'
    " But we want to look at 's' if it matches or not.
    while index-1 >= 0 && cmdline[index-1] !~ '\k'
        let index -= 1
    endwhile
    while index-1 >= 0 && cmdline[index-1] =~ '\k'
        let index -= 1
    endwhile
    let cmd = cmdline[startindex:-1]
    if index != 0
        let cmd = cmdline[0:index-1] .. cmd
    endif
    let killed = cmdline[index:startindex-1]
    if strlen(killed) != 0 && startindex != 0
        let s:CmdRegister = killed
        call setcmdpos(getcmdpos() - strlen(killed))
    endif
    call setcmdline(cmd)
endfunction

function! s:CmdKillLine()
    let l:curpos = getcmdpos()
    let cmdline = getcmdline()
    if curpos == 1
        let s:CmdRegister = cmdline
        call setcmdline("", 1)
    else
        let killed = cmdline[curpos-1:-1]
        if strlen(killed) != 0
            let s:CmdRegister = killed
        endif
        call setcmdline(cmdline[0:curpos-2], curpos)
    endif
endfunction

function! s:CmdBackwardKillLine()
    let l:curpos = getcmdpos()
    let l:cmdline = getcmdline()
    let deleted = cmdline[0:curpos-2]
    if curpos != 1
        let s:CmdRegister = deleted
    endif
    call setcmdline(cmdline[curpos-1:-1], 1)
endfunction

function! s:CmdYank()
    let curpos = getcmdpos()
    let cmdline = getcmdline()
    let cmd = s:CmdRegister .. cmdline[curpos-1:-1]
    if curpos != 1
        let cmd = cmdline[0:curpos-2] .. cmd
    endif
    call setcmdline(cmd, curpos + strlen(s:CmdRegister))
endfunction

" Command mode mapping for emacs/readline bindings
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
"cnoremap <C-N> <Down>
"cnoremap <C-P> <Up>
cnoremap <C-D> <Del>
cnoremap <M-f> <S-Right>
cnoremap <M-b> <S-Left>
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-w> <cmd>call <SID>CmdBackwardKillWord()<cr>
cnoremap <C-u> <cmd>call <SID>CmdBackwardKillLine()<cr>
cnoremap <M-d> <cmd>call <SID>CmdKillWord()<cr>
cnoremap <C-k> <cmd>call <SID>CmdKillLine()<cr>
cnoremap <C-y> <cmd>call <SID>CmdYank()<cr>


" TODO: Joins work but it changes the cursor position
" Best to do is save curpos with a mark and restore afterwards
function! s:InsertKillWord()
    let nextChar = GetChar()
    while nextChar !~ '\k'
      call feedkeys("\<Del>")
      echomsg "deleting " nextChar
      let nextChar = GetChar()
    endwhile
    while nextChar =~ '\k'
      call feedkeys("\<Del>")
      echomsg "deleting " nextChar
      let nextChar = GetChar()
    endwhile
    return

    let originalpos = getcurpos()
    let originalline = getline('.')
    let [_, linenr, colnr, _, _] = getcurpos()
    let index = colnr-1
    let line = originalline
    let linelen = strlen(line)
    let newline = ""
    if index != 0
      let newline = line[0:index-1]
    endif
    let deletionregion = [index, 0]
    while index < linelen && line[index] !~ '\k'
        let index += 1
	if index >= linelen
	    let next_linenr = nextnonblank(linenr + 1)
	    if next_linenr == 0
	      let deletionregion[1] = index-1

	      return
	    endif

	endif
    endwhile
    " NOTE: put this if statement in the loop above
    "       this could remove the duplicate while loop
    if index >= linelen
        let next_linenr = nextnonblank(linenr + 1)
	if next_linenr == 0
	  return
	endif
        let lines_joined = next_linenr - linenr + 1
        execute "normal! " .. lines_joined .. "gJ"
        let line = getline('.')
        let linelen = strlen(line)
        while index < linelen && line[index] !~ '\k'
            let index += 1
        endwhile
    endif
    while index < linelen && line[index] =~ '\k'
        let index += 1
    endwhile
    let newline = newline .. line[index:-1]
    let deletionregion[1] = index-1
    let deletedtext = line[deletionregion[0]: deletionregion[1]]
    if strlen(deletedtext) != 0
        let @" = deleted
    endif
    " NOTE: create new undo sequence with feedkeys("<c-g>u") inside the if?
    if newline != originalline
        call setline(".", newline)
    endif
    call setpos(".", originalpos)

endfunction

function! s:InsertKillLine()
    if GetChar() != ""
        call feedkeys("\<C-o>d$")
    endif
endfunction

" FIXME: with dv it will delete one char in front the cursor
"       so after many Ctrl-W, the word in front will be deleted
"       without dv, just db, it wont delete the last character of the
"       word/line/file
function! s:InsertBackwardKillWord()
    call feedkeys("\<C-o>dvb")
endfunction

" FIXME: Wont go up in the file, ie stay on the same line
function! s:InsertBackwardKillLine()
    call feedkeys("\<C-o>dv0")
endfunction

function! s:InsertYankPop()
    if pumvisible()
        call feedkeys("\<C-y>", "n")
    else
        call feedkeys("\<C-r>\"")
    endif
endfunction

" different strategies
"
" statement-style mapping, using getline/setline and joins
" expression-style mapping, with <expr> or Ctrl-R=, and return <Del> * number
" expression style with Ctrl-o and normal command
" feedkeys?

" Insert mode mapping for emacs/readline bindings
inoremap <C-F> <Right>
inoremap <C-B> <Left>
inoremap <M-f> <C-o>e<Right>
inoremap <M-b> <S-Left>
inoremap <C-A> <Home>
inoremap <expr> <C-E> pumvisible()?"<C-E>":"<End>"
inoremap <C-D> <Del>
"inoremap <C-h> backward-delete-char is a Vim default
inoremap <M-d> <cmd>call <SID>InsertKillWord()<cr><C-g>u
inoremap <C-w> <cmd>call <SID>InsertBackwardKillWord()<cr>
inoremap <C-k> <cmd>call <SID>InsertKillLine()<cr>
inoremap <C-u> <cmd>call <SID>InsertBackwardKillLine()<cr>
inoremap <expr> <C-y> pumvisible()?"<C-y>":"<C-R>\""
