local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank (vim.hl.on_yank is the 0.11 API)
autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
    group = augroup("trim-whitespace", { clear = true }),
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Return to last edit position when opening files
autocmd("BufReadPost", {
    group = augroup("last-position", { clear = true }),
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        local line_count = vim.api.nvim_buf_line_count(args.buf)
        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Resize splits when terminal is resized
autocmd("VimResized", {
    group = augroup("resize-splits", { clear = true }),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
})

-- Open snacks explorer when opening a directory
autocmd("BufEnter", {
    group = augroup("directory-browser", { clear = true }),
    callback = function(args)
        if vim.fn.isdirectory(vim.api.nvim_buf_get_name(args.buf)) == 1 then
            vim.api.nvim_buf_delete(args.buf, { force = true })
            Snacks.explorer()
        end
    end,
})

-- Auto-detect Python virtualenv (checks .venv, venv, .env, VIRTUAL_ENV)
autocmd("FileType", {
    group = augroup("python-venv", { clear = true }),
    pattern = "python",
    callback = function()
        -- Prefer VIRTUAL_ENV env var if set
        local venv = vim.env.VIRTUAL_ENV
        if not venv then
            -- Search for common venv directories
            local root = vim.fs.root(0, { "pyproject.toml", "setup.py", "requirements.txt", ".git" })
            if root then
                for _, name in ipairs({ ".venv", "venv", ".env" }) do
                    local path = root .. "/" .. name
                    if vim.fn.isdirectory(path) == 1 then
                        venv = path
                        break
                    end
                end
            end
        end
        if venv then
            vim.env.VIRTUAL_ENV = venv
            vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
        end
    end,
})

-- Filetype-specific indent (2 spaces for web)
autocmd("FileType", {
    group = augroup("filetype-settings", { clear = true }),
    pattern = { "javascript", "typescript", "typescriptreact", "json" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
    end,
})
