if vim.fn.exists('NO_WORKSPACE') == 1 then
    return
end
local result = vim.fn.systemlist("workspace")
if vim.v.shell_error ~= 0 then return end
local config_home = result[1] .. "/nvim"
vim.g.workspaceLocation = result[1]

local augroup = vim.api.nvim_create_augroup('Sessions', {})
-- If its the first time launching vim in a config_home folder
-- we need to create it and create a first session file
-- the shada file will be created later in the neovim startup sequence
local shada = config_home .. "/workspace.shada"
-- vim.print(shada)
local nvimrc = config_home .. "/nvimrc"
local vimscript = config_home .. "/script.vim"
local luascript = config_home .. "/script.lua"

if vim.fn.isdirectory(config_home) == 0 then vim.fn.mkdir(config_home, "p") end
if vim.fn.filereadable(nvimrc) == 0 then vim.cmd('mkvimrc ' .. nvimrc) end
if vim.fn.filereadable(vimscript) == 0 then vim.fn.writefile({}, vimscript) end
if vim.fn.filereadable(luascript) == 0 then vim.fn.writefile({}, luascript) end

vim.o.shada = "!,'100,<50,s10,h"
vim.o.shadafile = shada

-- vim.o.sessionoptions = "curdir,globals,options"
-- local session = config_home .. "/Session.vim"
local workspaceWinId = -1
local edit_workspace = function()
    if vim.fn.win_gotoid(workspaceWinId) == 0 then
        vim.cmd("tabnew " .. vim.g.workspaceLocation)
        vim.cmd("tcd " .. vim.g.workspaceLocation)
        workspaceWinId = vim.fn.win_getid()
    end
end
vim.api.nvim_create_user_command("EditWorkspaceState", edit_workspace, {nargs = 0})
vim.keymap.set("n", "<C-x><C-e>", "<cmd>EditWorkspaceState<cr>")
vim.keymap.set("n", "<C-x><C-d>", "<cmd>CdWorkspacePath<cr>")

vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.cmd("silent source " .. nvimrc)
        vim.cmd("silent source " .. vimscript)
        vim.cmd("silent source " .. luascript)
        require'colors'.set_colorscheme(vim.o.background, vim.g.COLOR_NAME)
    end
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup,
    pattern = "*",
    callback = function()
        vim.g.COLOR_NAME = vim.g.colors_name
        vim.cmd("mkvimrc! " .. nvimrc)
    end
})
