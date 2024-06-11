require 'lspconfig'.lua_ls.setup {
    root_dir = require 'lspconfig.util'.root_pattern('init.vim', 'init.lua', 'luarc.json'),
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if path == vim.fn.stdpath('config') then
            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = {
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })
            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
        end
        return true
    end,
    settings = {
        Lua = {
            diagnostics = {globals = {'vim', "vim"}}
        }
    }
}
