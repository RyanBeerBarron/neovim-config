function config#open(...) abort
    if a:0 == 0
        execute 'edit ' .. stdpath('config')
        return
    endif
    const config_file = a:1
    if filereadable(config_file)
        execute 'edit ' .. config_file
        return
    endif
    echoerr 'Path ' .. config_file .. ' is not a known configuration config file'
endfunction

function config#grep(args) abort
    let wildignore_save = &wildignore
    defer s:restore_wildignore(wildignore_save)

    let search_paths = g:config_path->mapnew({_, path -> path .. '/**'})->join(' ')
    let &wildignore = '*/pack/*'
    execute 'vimgrep /\C' .. a:args .. '/ ' .. search_paths
endfunction

" TODO: Handle multiple arguments to find a match
" like 'lemminx config' => lua/java/lemminx/config.lua
" Problem => it will only replace the second argument with the found match
" 'lemminx lua/java/lemminx/config.lua'
" Either not possible or ignore arguments before the last
function config#completion_config(arglead, cmdline, cursorpos) abort
    let wildignore_save = &wildignore
    defer s:restore_wildignore(wildignore_save)

    let search_pattern = '*'
    if a:arglead != ''
        let search_pattern = '*' .. a:arglead .. '*'
    endif

    let &wildignore = '*/pack/*'
    let match = globpath(g:config_path->join(','), '**/' .. search_pattern, 0, 1)
                \ ->map({_, path -> s:expand_dir(path)})->flatten()
    return match
endfunction

function s:expand_dir(path) abort
    if isdirectory(a:path)
        let list = glob(a:path .. '/**', 0, 1)->filter({_, path -> filereadable(path)})
        return list
    endif
    return a:path
endfunction

function s:restore_wildignore(wildignore_backup) abort
    let &wildignore = a:wildignore_backup
endfunction
