local cmp = require("cmp")

cmp.setup({
    -- CoC owns completion for filetypes with a CoC extension; cmp handles the rest.
    enabled = function()
        return not vim.tbl_contains({ "go", "javascript", "javascriptreact", "typescript", "typescriptreact", "python" }, vim.bo.filetype)
    end,

    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },

    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        -- <Tab> intentionally unbound: reserved for Windsurf suggestions.
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
    }, {
        { name = "buffer" },
        { name = "path" },
    }),
})
