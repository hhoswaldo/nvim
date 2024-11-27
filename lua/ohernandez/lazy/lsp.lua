return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "pyright",
                "marksman",
                "dockerls",
                "docker_compose_language_service",
                "yamlls"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["pyright"] = function()
                    local lspconfig = require("lspconfig")
                    local function get_python_path()
                        local venv_path = vim.fn.getcwd() .. "/.venv/bin/python"
                        if vim.fn.executable(venv_path) == 1 then
                            return venv_path
                        else
                            return "/usr/bin/python"
                        end
                    end
                    lspconfig.pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                pythonPath = get_python_path(),
                            }
                        }
                    }
                end,
                ["marksman"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.marksman.setup {
                        capabilities = capabilities,
                    }
                end,
                ["dockerls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.dockerls.setup {
                        capabilities = capabilities,
                    }
                end,
                ["docker_compose_language_service"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.docker_compose_language_service.setup {
                        capabilities = capabilities,
                        filetypes = { "yaml.docker-compose" },
                    }
                end,
                ["yamlls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.yamlls.setup {
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemas = {
                                    ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
                                },
                                schemaStore = {
                                    enable = true,
                                    url = "https://www.schemastore.org/api/json/catalog.json"
                                },
                                validate = true,
                                format = {
                                    enable = true,
                                },
                                hover = true,
                                completion = true,
                            }
                        },
                        filetypes = { "yaml", "yaml.github-actions" }
                    }
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
