return {
    "laytan/cloak.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
            {
                file_pattern = { ".env*", "*.env", "*.secret", "*.secrets" },
                cloak_pattern = "=.+",
                replace = nil, -- replaces each char with cloak_character
            },
        },
    },
    keys = {
        { "<leader>ct", "<cmd>CloakToggle<CR>", desc = "Toggle cloak" },
    },
}
