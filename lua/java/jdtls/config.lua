-- vim: foldmethod=marker
local jdtls = require'jdtls'
--- @type vim.lsp.ClientConfig
local M = { cmd = {"jdtls"} }

-- capabilities
local capabilities = vim.tbl_deep_extend("force",
    vim.lsp.protocol.make_client_capabilities(),
    require'cmp_nvim_lsp'.default_capabilities())

local function on_init(jdtls) -- {{{
    Jdtls = jdtls
    vim.api.nvim_create_autocmd({"BufEnter", "InsertLeave"}, {
        group = vim.api.nvim_create_augroup("JavaLSPConfig", {clear=false}),
        pattern = "*.java",
        desc = "Autocmd to refresh code lens when entering a buffer or leaving insert mode",
        callback = function()
            vim.lsp.codelens.refresh({ bufnr = 0 })
        end
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("JavaLSPConfig", {clear=false}),
        pattern = 'java',
        callback = function()
            vim.lsp.buf_attach_client(0, jdtls.id)
        end
    })
    vim.keymap.set("n", "<space>ws", function()
        jdtls.request(vim.lsp.protocol.Methods.workspace_symbol, { query = vim.fn.input("Query: ") }, nil, 0)
    end,
    { noremap = true, desc = "Find given symbol in entire project" })
end -- }}}

local function on_attach(client, bufnr) -- {{{
        vim.lsp.codelens.refresh()
        local opts = function(desc)
        return {
            noremap = true,
            desc = desc,
            buffer = true
        }
    end
    vim.keymap.set("n", "<A-o>", "<cmd>lua require'jdtls'.organize_imports()<cr>", opts("Organize java imports"))
    vim.keymap.set({"n", "v"}, "crv", "<cmd>lua require'jdtls'.extract_variable()<cr>", opts("Extract java variable"))
    vim.keymap.set({"n", "v"}, "crc", "<cmd>lua require'jdtls'.extract_constant()<cr>", opts("Extract java constant"))
    vim.keymap.set("v", "crm", "<cmd>lua require'jdtls'.extract_method()<cr>", opts("Extract java method"))
    vim.keymap.set("n", "<A-o>", "<cmd>lua require'jdtls'.organize_imports()<cr>", opts("Organize java imports"))
end -- }}}

-- java settings {{{
local java = {}

-- codeGeneration {{{
local codeGeneration = {
    addFinalForNewDeclaration = 'all',
    generateComments = true,
    hashCodeEquals = {
        useInstanceof = false,
        useJava7Objects = false
    },
    -- String: any of 'afterCursor', 'beforeCursor' or 'lastMember'
    insertionLocation = 'afterCursor',
    toString = {
        -- String: any of "STRING_CONCATENATION", "STRING_BUILDER", "STRING_BUILDER_CHAINED" or "STRING_FORMAT"
        -- taken from eclipse jdtls 'GenerateToStringHandler#getToStringStyle'
        codeStyle = 'STRING_BUILDER_CHAINED',
        skipNullValues = false,
        listArrayContents = true,
        limitElements = 0
    },
    useBlocks = true
} -- }}}

-- completion {{{
local completion = {
    enabled = true,
    -- favoriteStaticMembers = {},
    -- filteredTypes = {},
    -- String any of: 'off', 'insertParameterNames' or 'insertBestGuessedArguments'
    -- from jdtls 'CompletionGuessMethodArgumentsMode#fromString'
    guessMethodArguments = 'insertBestGuessedArguments',
    -- importOrder = {},
    -- String, any of: 'OFF' or 'FIRSTLETTER'
    -- from jdtls 'CompletionMatchCaseMode#fromString'
    matchCase = 'FIRSTLETTER',
    maxResults = 0,
    overwrite = false,
    postfix = {
        enabled = true
    }
}
-- }}}

-- configuration {{{
local configuration = {
    updateBuildConfiguration = "interactive",
    maven = {
      userSettings = os.getenv('XDG_CONFIG_HOME') .. '/maven/settings.xml',
      globalSettings = os.getenv('XDG_CONFIG_HOME') .. '/maven/settings.xml',
      -- notCoveredPluginExecutionSeverity = String but idk
    }
} -- }}}

-- format {{{
-- TODO: disable format from LSP -> enable formatter per workspace without LSP support
local format = {
    comments = { enabled = false },
    enabled = true,
    insertSpaces = true,
    onType = { enabled = true },
    tabSize = 4
} -- }}}

-- jdt {{{
local jdt = {
    ls = {}
}
jdt.ls.androidSupport = { enabled = false }
jdt.ls.lombokSupport = { enabled = true }
jdt.ls.protofBufSupport = { enabled = false } -- }}}

-- sources {{{
local sources = { organizeImports = {}}
sources.organizeImports.starThreshold = 9999
sources.organizeImports.staticStarThreshold = 9999 -- }}}

java.autobuild = { enabled = false }
java.codeAction = {
    sortMembers = {
        avoidVolatileChanges = false
    }
}
java.codeGeneration = codeGeneration
java.completion = completion
java.configuration = configuration
java.contentProvider = { preferred = 'fernflower' }
java.eclipse = { downloadSources = true }
java.errors = {
    incompleteClasspath = {
        severity = 'warning'
    }
}
java.executeCommand = { enabled = true }
java.foldingRange = { enabled = true }
java.format = format
java.home = '/home/ryan/local/jdks/current'
java.implementationsCodeLens = { enabled = true }
java.inlayHints = {
    parametersNames = { enabled = 'all' }
}
java.jdt = jdt
java.maven = { downloadSources = true }
java.maxConcurrentBuilds = 0
java.memberSortOrder = 'T,SF,F,C,SI,I,SM,M'
java.referencesCodeLens = { enabled = true }
java.references = {
    includeAccessors = true,
    includeDecompiledSources = true
}
java.rename = { enabled = true }
java.saveActions = { organizeImports = false }
java.selectionRange = { enabled = true }
java.signatureHelp = {
    enabled = true,
    description = { enabled = true }
}
java.server = { launchMode = "Standard" }
java.sources = sources
java.symbols = { includeSourceMethodDeclarations = true }
java.trace = { server = 'messages' }
java.project = {}
-- }}}

M.capabilities = capabilities
M.detached = false
M.flags = {
    allow_incremental_sync = true,
    debounce_text_changes = 150,
    exit_timeout = false
}
M.on_attach = on_attach
M.on_init = on_init
M.root_dir = vim.fn.getcwd()
M.settings = { java = java }
M.trace = 'verbose'
jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

return M
