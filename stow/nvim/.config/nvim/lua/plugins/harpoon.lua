return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon add" },
        { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
        { "<localleader>a", function() require("harpoon"):list():select(1) end, desc = "Harpoon 1" },
        { "<localleader>s", function() require("harpoon"):list():select(2) end, desc = "Harpoon 2" },
        { "<localleader>d", function() require("harpoon"):list():select(3) end, desc = "Harpoon 3" },
        { "<localleader>f", function() require("harpoon"):list():select(4) end, desc = "Harpoon 4" },
    },
    config = function()
        require("harpoon"):setup()
    end,
}
