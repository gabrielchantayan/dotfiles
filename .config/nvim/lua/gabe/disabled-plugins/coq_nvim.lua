-- Plugin: ms-jpq/coq_nvim
-- Installed via store.nvim

return {
    "ms-jpq/coq_nvim",
    dependencies = {
        "ms-jpq/coq.artifacts",
        "ms-jpq/coq.thirdparty"
    },
    event = "VeryLazy"
}