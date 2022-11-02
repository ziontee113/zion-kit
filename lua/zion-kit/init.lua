local M = {}
local Buffer = require "zion-kit.lib.buffer"
local Window = require "zion-kit.lib.window"

vim.keymap.set("n", "<A-=>", function()
    local buf1 = Buffer:new()
    local win1 = Window:new({
        bufnr = buf1.bufnr,
        open_window_options = {
            width = 30,
            height = 10,
        },
    })
    buf1:set_content({ "look at me" })

    local buf2 = Buffer:new()
    local win2 = Window:new({
        bufnr = buf2.bufnr,
        open_window_options = {
            relative = "editor",
            width = 20,
            height = 10,
        },
        window_options = {
            cursorline = true,
        },
    })
    buf2:set_content({ "look at me now" })

    vim.keymap.set("n", "<Tab>", function()
        win1:jump_to()
    end, { buffer = buf2.bufnr })
    vim.keymap.set("n", "<Tab>", function()
        win2:jump_to()
    end, { buffer = buf1.bufnr })
end, {})

vim.keymap.set("n", "<A-BS>", function()
    ---@diagnostic disable-next-line: undefined-global
    R "zion-kit"
    ---@diagnostic disable-next-line: undefined-global
    N "zion-kit reloaded"
end, {})

return M
