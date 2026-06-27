return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
        options = {
            theme = "auto",
            globalstatus = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } },
            lualine_x = {
                {
                    function()
                        local venv = vim.env.VIRTUAL_ENV
                        if not venv then return "" end
                        local venv_name = vim.fn.fnamemodify(venv, ":t")
                        local python = venv .. "/bin/python"
                        if vim.fn.executable(python) == 1 then
                            local version = vim.fn.system(python .. " --version 2>&1")
                            version = version:match("Python%s+(%S+)")
                            if version then
                                return "  " .. venv_name .. " (" .. version .. ")"
                            end
                        end
                        return "  " .. venv_name
                    end,
                    cond = function()
                        return vim.bo.filetype == "python"
                    end,
                    color = { fg = "#CBA6F7" },
                },
                "filetype",
            },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    },
}
