return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "uv.lock", ".git" },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly", -- faster for large codebases
                typeCheckingMode = "standard",
                inlayHints = {
                    variableTypes = true,
                    callArgumentNames = "partial",
                    functionReturnTypes = true,
                    genericTypes = true,
                },
            },
        },
    },
}
