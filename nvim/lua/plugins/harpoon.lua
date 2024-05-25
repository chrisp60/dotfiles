local set = vim.keymap.set
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            set("n", "sa", function()
                harpoon:list():add()
            end)
            set("n", "sm", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)
            set("n", "sj", function()
                harpoon:list():select(1)
            end)
            set("n", "sk", function()
                harpoon:list():select(2)
            end)
            set("n", "sl", function()
                harpoon:list():select(3)
            end)
            set("n", "s;", function()
                harpoon:list():select(4)
            end)
            set("n", "sp", function()
                harpoon:list():prev()
            end)
            set("n", "sn", function()
                harpoon:list():next()
            end)
        end,
    },
}
