-- vim: foldmethod=marker
if vim.fn.exists('g:long_session') == 0 then
    return ''
end
local workspace = vim.fn.systemlist("workspace")
if vim.v.shell_error ~= 0 then
    return ''
end
local nvim_workspace = workspace[1] .. "/nvim"
local site = nvim_workspace .. '/site'
local swap = nvim_workspace .. "/swapfile//"
local shada = nvim_workspace .. "/workspace.shada"
local undo = nvim_workspace .. "/undo//"

local rtp_directories = {
    "after", "autoload", "compiler",
    "doc", "ftplugin", "lua",
    "pack", "parser", "plugin",
    "queries", "rplugin"
}

if vim.fn.isdirectory(nvim_workspace) == 0 then vim.fn.mkdir(nvim_workspace, "p") end
vim.g.workspaceLocation = workspace[1]
vim.g.workspace = 1

if vim.fn.isdirectory(swap) == 0 then vim.fn.mkdir(swap, "p") end
vim.o.directory = swap

if vim.fn.isdirectory(undo) == 0 then vim.fn.mkdir(undo, "p") end
vim.o.undodir = undo

vim.o.shada = "!,'100,<50,s10,h"
vim.o.shadafile = shada

if vim.fn.isdirectory(site) == 0 then vim.fn.mkdir(site, "p") end

local nvimrc = site .. "/nvimrc"
if vim.fn.filereadable(nvimrc) == 0 then vim.cmd('mkvimrc ' .. vim.fn.fnameescape(nvimrc)) end
for _, dir in pairs(rtp_directories) do
    if vim.fn.isdirectory(site .. "/" ..  dir) == 0 then vim.fn.mkdir(site .. "/" ..  dir, "p") end
end
vim.o.rtp = site .. "," .. vim.o.rtp
vim.o.rtp = vim.o.rtp .. site .. "/after,"

-- COMMANDS
local workspaceWinId = -1
local edit_workspace = function() --{{{
    if vim.fn.win_gotoid(workspaceWinId) == 0 then
        vim.cmd("tabnew " .. vim.fn.fnameescape(vim.g.workspaceLocation))
        vim.cmd("tcd " .. vim.fn.fnameescape(vim.g.workspaceLocation))
        workspaceWinId = vim.fn.win_getid()
        return
    end
    vim.cmd("edit " .. vim.fn.fnameescape(vim.g.workspaceLocation))
end
vim.keymap.set("n", "<leader>ws", edit_workspace, {
    desc = "Create a new tab inside workspace config directory with tab local cwd"
}) -- }}}

vim.api.nvim_create_augroup('Workspace', {clear=true})
vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup('Workspace', {clear=false}),
    pattern = "*",
    callback = function()
        vim.cmd("silent source " .. vim.fn.fnameescape(nvimrc))
        require'colors'.set_colorscheme(vim.o.background, vim.g.COLOR_NAME)
    end,
    desc = "Load workspace's nvimrc for mappings and options"
})
vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup('Workspace', {clear=false}),
    pattern = "*",
    callback = function()
        vim.g.COLOR_NAME = vim.g.colors_name
        vim.cmd("mkvimrc! " .. vim.fn.fnameescape(nvimrc))
    end,
    desc = "Save current mappings and options to workspace's nvimrc"
})

local function reset()
    vim.fn.delete(nvimrc)
    vim.fn.delete(shada)
    vim.api.nvim_clear_autocmds({
        group = vim.api.nvim_create_augroup('Workspace', {clear=true})
    })
end
vim.api.nvim_create_user_command("WorkspaceReset", reset, {nargs = 0})
return site
