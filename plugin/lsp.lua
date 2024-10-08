local lspconfig = require("lspconfig")
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions


local function deactivate_semantic_tokens()
    for _, client in ipairs(vim.lsp.get_clients()) do
        vim.lsp.semantic_tokens.stop(vim.fn.bufnr(), client.id)
    end
end
local function activate_semantic_tokens()
    for _, client in ipairs(vim.lsp.get_clients()) do
        vim.lsp.semantic_tokens.start(vim.fn.bufnr(), client.id)
    end
end
vim.api.nvim_create_user_command('LspHighlightingStop', deactivate_semantic_tokens, {})
vim.api.nvim_create_user_command('LspHighlightingStart', activate_semantic_tokens, {})
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
        buffer = 0,
        callback = function(ev)
            vim.lsp.buf.document_highlight()
        end
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = 0,
        callback = function(ev)
            vim.lsp.buf.clear_references()
        end
    })
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<space>H', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>ic', vim.lsp.buf.incoming_calls, opts)
    vim.keymap.set('n', '<space>oc', vim.lsp.buf.outgoing_calls, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', vim.lsp.buf.list_workspace_folders, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

lspconfig.gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

local function cdRootDir()
    local lsp = vim.lsp
    local root_dir = lsp.get_active_clients({ bufnr = 0 })[1].config["root_dir"]
    if root_dir ~= nil then
        vim.api.nvim_set_current_dir(root_dir)
        print("Now in " .. root_dir)
    end
end
vim.keymap.set('n', '<space>rd', cdRootDir)


vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

vim.lsp.inlay_hint.enable(true)
vim.api.nvim_create_user_command("InlayHintsToggle", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, {})
