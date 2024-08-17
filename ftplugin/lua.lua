require 'lspconfig'.lua_ls.setup {
    root_dir = require 'lspconfig.util'.root_pattern('init.vim', 'init.lua', 'nvimrc', 'luarc.json'),
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT'
            },
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
}
