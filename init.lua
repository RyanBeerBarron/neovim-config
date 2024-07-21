---@type string[]
---@diagnostic disable-next-line: assign-type-mismatch
local config_paths = { vim.fn.stdpath("config") }

---@type string?
local workspace_path = require'workspace'
if workspace_path ~= '' then
    table.insert(config_paths, workspace_path)
end

vim.g.config_path = config_paths
