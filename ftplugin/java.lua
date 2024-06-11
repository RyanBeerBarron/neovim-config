local jdtls = require 'jdtls'
local springboot = require 'spring_boot'

local springboot_extension_dir = vim.fn.glob('/home/ryan/tools/vmware.vscode-spring-boot-*')
vim.g.spring_boot = {
    jdt_extensions_path = springboot_extension_dir .. '/extension/jars',
    jdt_extensions_jars = {
        "io.projectreactor.reactor-core.jar",
        "org.reactivestreams.reactive-streams.jar",
        "jdt-ls-commons.jar",
        "jdt-ls-extension.jar",
    }
}
springboot.init_lsp_commands()
-- TODO: Read the entire 'vim.lsp' help page
-- Finish setting up the springboot LSP
-- currently, I get an error when first entering a java file, and must re-edit the file for the ftplugin to trigger
-- a second time and the springboot language server to finally launch.
-- Explore the workspace/Symbol methods to find Constants/Classes/Enums/Interfaces/etc... in the project => Ctrl-n for fuzzy find class
-- And also that would allow me to find springboot symbols, like endpoints
--

-- local capabilities = {
--     workspace = {
--         configuration = true
--     },
--     textDocument = {
--         completion = {
--             completionItem = {
--                 snippetSupport = true
--             }
--         }
--     }
-- }

jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
local cmp_capabilities = require 'cmp_nvim_lsp'.default_capabilities()
local capabilities = vim.tbl_extend("keep", vim.lsp.protocol.make_client_capabilities(), cmp_capabilities)

local function tagfunc(pattern)
    return vim.lsp.tagfunc(pattern, "c")
end


local arr = vim.fn.systemlist("workspace")
local root_dir = arr[1]
local config = {
    capabilities = capabilities,
    cmd = { "jdtls", vim.fs.basename(root_dir) },
    on_attach = function(client)
        vim.lsp.codelens.refresh()
        springboot.setup({
            ls_path = springboot_extension_dir .. '/extension/language-server',
            jdtls_name = 'jdtls',
            log_file = nil
        })
        -- vim.bo.tagfunc = tagfunc
    end,
    flags = { allow_incremental_sync = true },
    root_dir = vim.fn.getcwd(),
    detached = false,
    init_options = {
        bundles = springboot.java_extensions()
    },
    settings = {
        java = {
            autobuild = {
                enabled = false
            },
            codeAction = {
                sortMembers = {
                    avoidVolatileChanges = false
                }
            },
            codeGeneration = {
                addFinalForNewDeclaration = 'all',
                generateComments = true,
                hashCodeEquals = {
                    useInstanceof = false,
                    useJava7Objects = false
                },
                -- String: any of 'afterCursor', 'beforeCursor' or 'lastMember'
                insertionLocation = 'afterCursor',
                toString = {
                    -- template
                    -- String: any of "STRING_CONCATENATION", "STRING_BUILDER", "STRING_BUILDER_CHAINED" or "STRING_FORMAT"
                    -- taken from eclipse jdtls 'GenerateToStringHandler#getToStringStyle'
                    codeStyle = 'STRING_BUILDER_CHAINED',
                    skipNullValues = false,
                    listArrayContents = true,
                    limitElements = 0
                },
                useBlocks = true
            },
            completion = {
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
            },
            configuration = {
                updateBuildConfiguration = "interactive",
                maven = {
                    userSettings = os.getenv('XDG_CONFIG_HOME') .. '/maven/settings.xml',
                    globalSettings = os.getenv('XDG_CONFIG_HOME') .. '/maven/settings.xml',
                    -- notCoveredPluginExecutionSeverity = String but idk
                }
            },
            contentProvider = {
                preferred = 'fernflower'
            },
            eclipse = {
                downloadSources = true
            },
            errors = {
                incompleteClasspath = {
                    severity = 'warning'
                }
            },
            executeCommand = {
                enabled = true
            },
            foldingRange = {
                enabled = true
            },
            format = {
                comments = {
                    enabled = false
                },
                enabled = true,
                insertSpaces = true,
                onType = {
                    enabled = true
                },
                -- settings = {
                --     profile = 'ryan',
                --     url = path/to/formatter/file.xml
                -- },
                tabSize = 4
            },
            home = '/home/ryan/local/jdks/current',
            implementationsCodeLens = {
                enabled = true
            },
            -- import = {
            --     exclusions
            --     gradle
            --     maven
            -- },
            inlayHints = {
                parametersNames = {
                    enabled = 'all'
                }
            },
            jdt = {
                ls = {
                    androidSupport = {
                        enabled = false
                    },
                    lombokSupport = {
                        enabled = true
                    },
                    protofBufSupport = {
                        enabled = false
                    }
                }
            },
            maven = {
                downloadSources = true
            },
            maxConcurrentBuilds = 0,
            memberSortOrder = "T,SF,F,C,SI,I,SM,M",
            project = {
                -- encoding
                -- outputPath: Only useful for eclipse project
                -- referencedLibraries
                -- resourceFilters
                -- sourcePath: Only useful for eclipse project
            },
            -- quickfix = {
            -- showAt: String defaults to 'line'
            -- },
            referencesCodeLens = {
                enabled = true
            },
            references = {
                includeAccessors = true,
                includeDecompiledSources = true
            },
            rename = {
                enabled = true
            },
            saveActions = {
                organizeImports = false
            },
            selectionRange = {
                enabled = true
            },
            -- settings = {
            --     used for compiler options
            --     url = path/to/properties/file
            -- },
            signatureHelp = {
                enabled = true,
                description = { enabled = true }
            },
            server = {
                -- Either 'Standard', 'Hybrid' or 'LightWeight'
                launchMode = "Standard"
            },
            sources = {
                organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999
                }
            },
            symbols = {
                includeSourceMethodDeclarations = true
            },
            -- templates = {
            --     fileHeader = comment to put as header when creating new file
            --     typeComment = comment to put when creating new type
            -- },
            trace = {
                server = 'messages'
            },
            -- edit = {
            --
            -- }
        },
    },
}
require 'treesitter-context'.setup {
    enable = false
}


if vim.g.ENABLE_JDTLS == 1 then jdtls.start_or_attach(config) end
