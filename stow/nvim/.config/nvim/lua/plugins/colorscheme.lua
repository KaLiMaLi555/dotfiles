return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local float_bg = "#16161e" -- tokyonight night dark bg

        require("tokyonight").setup({
            style = "night",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "dark",
                floats = "dark",
            },
            on_highlights = function(hl, c)
                hl.LineNr = { fg = "#b0b4d0" }
                hl.LineNrAbove = { fg = "#b0b4d0" }
                hl.LineNrBelow = { fg = "#b0b4d0" }
                -- Solid dark blue floats with matching border
                hl.NormalFloat = { bg = float_bg }
                hl.FloatBorder = { fg = "#b0b4d0", bg = float_bg }
                hl.FloatTitle = { fg = "#b0b4d0", bg = float_bg }
            end,
        })
        vim.cmd.colorscheme("tokyonight")
    end,
}
