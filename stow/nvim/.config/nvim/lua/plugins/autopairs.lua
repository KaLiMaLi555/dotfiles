return {
    "saghen/blink.pairs",
    version = "1.*",
    dependencies = { "saghen/blink.cmp" },
    build = "cargo build --release",
    event = "InsertEnter",
    opts = {
        highlights = {
            enabled = true,
        },
    },
}
