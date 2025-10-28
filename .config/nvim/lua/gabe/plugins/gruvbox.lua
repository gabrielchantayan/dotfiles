-- Plugin: morhetz/gruvbox
-- Added by store.nvim on 2025-10-27 10:40:56
return { "morhetz/gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
        -- Optionally configure and load the colorscheme
        -- directly inside the plugin declaration
        vim.g.gruvbox_material_enable_italic = true
        vim.cmd.colorscheme("gruvbox")
    end
}
