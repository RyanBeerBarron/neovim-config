--- @type vim.lsp.ClientConfig
local M = {
    name = "nvim_lua-ls",
    cmd = { "lua-language-server" },
    detached = false,
    trace = 'verbose'
}

-- capabilities
local capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require'cmp_nvim_lsp'.default_capabilities())

local settings = {}



local workspaces = {}
for _, path in ipairs(vim.g.config_path) do
    table.insert(workspaces, {
        uri = vim.uri_from_fname(path),
        name = path
    })
end
M.capabilities = capabilities
M.workspace_folders = workspaces

return M
