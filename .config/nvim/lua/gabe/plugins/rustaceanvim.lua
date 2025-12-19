-- Plugin: mrcjkb/rustaceanvim
-- Installed via store.nvim

return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
        vim.g.rustaceanvim = {
            -- LSP configuration
            server = {
                default_settings = {
                    ["rust-analyzer"] = {
                        -- Enable auto-imports
                        completion = {
                            autoimport = {
                                enable = true,
                            },
                        },
                        -- Enable inlay hints (types, parameter names, etc.)
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            chainingHints = { enable = true },
                            closingBraceHints = { enable = true },
                            closureReturnTypeHints = { enable = "always" },
                            lifetimeElisionHints = { enable = "always" },
                            parameterHints = { enable = true },
                            reborrowHints = { enable = "always" },
                            typeHints = { enable = true },
                        },
                        -- Improve code analysis
                        check = {
                            command = "clippy",
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    -- Enable inlay hints for this buffer
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                    -- Keymaps for LSP (only for Rust buffers)
                    local opts = { buffer = bufnr, silent = true }
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
                    vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                end,
            },
        }
    end,
}