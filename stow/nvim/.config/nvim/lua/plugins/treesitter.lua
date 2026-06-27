return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            ensure_installed = {
                "bash",
                "json",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "toml",
                "vim",
                "vimdoc",
                "typescript",
                "javascript",
                "html",
                "css",
            },
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            -- Selection keymaps
            local select_maps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            }
            for key, query in pairs(select_maps) do
                vim.keymap.set({ "x", "o" }, key, function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
                end, { desc = "TS: " .. query })
            end

            -- Move keymaps
            local moves = {
                ["]f"] = { query = "@function.outer", desc = "Next function" },
                ["]c"] = { query = "@class.outer", desc = "Next class" },
                ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
            }
            for key, opts in pairs(moves) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    require("nvim-treesitter-textobjects.move").goto_next_start(opts.query, "textobjects")
                end, { desc = opts.desc })
            end

            local moves_prev = {
                ["[f"] = { query = "@function.outer", desc = "Prev function" },
                ["[c"] = { query = "@class.outer", desc = "Prev class" },
                ["[a"] = { query = "@parameter.inner", desc = "Prev argument" },
            }
            for key, opts in pairs(moves_prev) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start(opts.query, "textobjects")
                end, { desc = opts.desc })
            end

            -- Swap keymaps
            vim.keymap.set("n", "<leader>sa", function()
                require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
            end, { desc = "Swap with next argument" })

            vim.keymap.set("n", "<leader>sA", function()
                require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
            end, { desc = "Swap with prev argument" })
        end,
    },
}
