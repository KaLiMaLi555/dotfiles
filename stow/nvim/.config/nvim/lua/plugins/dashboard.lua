return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                header = [[
██╗  ██╗ █████╗ ██╗     ██╗███╗   ███╗ █████╗ ██╗     ██╗
██║ ██╔╝██╔══██╗██║     ██║████╗ ████║██╔══██╗██║     ██║
█████╔╝ ███████║██║     ██║██╔████╔██║███████║██║     ██║
██╔═██╗ ██╔══██║██║     ██║██║╚██╔╝██║██╔══██║██║     ██║
██║  ██╗██║  ██║███████╗██║██║ ╚═╝ ██║██║  ██║███████╗██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝]],
                keys = {
                    { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
            sections = {
                { section = "header" },
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        },
        picker = {
            enabled = true,
        },
        explorer = {
            enabled = true,
        },
    },
    keys = {
        -- Find
        { "<C-p>", function() Snacks.picker.git_files() end, desc = "Git files" },
        { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find files" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
        { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
        { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
        -- File explorer
        { "<leader>fe", function() Snacks.explorer() end, desc = "File explorer" },
    },
}
