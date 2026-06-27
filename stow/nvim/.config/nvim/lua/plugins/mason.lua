return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                -- LSP servers
                "lua-language-server",
                "basedpyright",
                "typescript-language-server",
                -- Formatters
                "stylua",
                "prettier",
                -- Python (ruff replaces black, isort, pylint, mypy)
                "ruff",
                -- Linters
                "eslint_d",
            },
        },
    },
}
