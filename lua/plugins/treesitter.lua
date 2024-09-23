return {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opts = {
        sync_install = false,
        auto_install = true,
        additional_vim_regex_highlighting = false,
        highlight = { enable = true },
        ensure_installed = {
            "c",
            "python",
            "lua",
            "rust",
            "markdown",
            "markdown_inline",
            "vim",
            "javascript",
            "typescript",
        },
    },
}
