-- vim: foldmethod=marker
--- @type vim.lsp.ClientConfig
local M = {cmd = {"lemminx"}}

-- capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- vim.tbl_deep_extend("force",
--     vim.lsp.protocol.make_client_capabilities(),
--     require'cmp_nvim_lsp'.default_capabilities())

local function on_init(lemminx) -- {{{
    Lemminx = lemminx
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("JavaLSPConfig", {clear=false}),
        pattern = 'xml',
        callback = function()
            vim.lsp.buf_attach_client(0, lemminx.id)
        end
    })
    -- TODO: Make another keybind for lemminx symbols
    -- vim.keymap.set("n", "<space>ws", function()
    --     lemminx.request(vim.lsp.protocol.Methods.workspace_symbol, { query = vim.fn.input("Query: ") }, nil, 0)
    -- end,
    -- { noremap = true, desc = "Find given symbol in entire project" })

end -- }}}


local function on_attach(client, bufnr) -- {{{
    -- TODO: Some keybind for closing a tag? or some maven specific command?
    -- Can use another, simpler plugin for matching tags/closing tags
end -- }}}

-- xml settings {{{
local xml = {}

-- }}}
--
M.name = "lemminx"
M.capabilities = capabilities
M.detached = false
M.flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
    exit_timeout = false
}
M.on_init = on_init
M.root_dir = vim.fn.getcwd()
-- M.handlers ??
-- M.commands ??
M.settings = { xml = xml }
M.trace = 'verbose'

return M
