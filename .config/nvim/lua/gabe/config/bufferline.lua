require("bufferline").setup {
    options = {
        seperator_style = "slant",
        max_name_length = 24,
        tab_size = 24,
        numbers = "buffer_id",
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",      
        separator = true -- use a "true" to enable the default, or set your own character
    }
}
