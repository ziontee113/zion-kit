local M = {}
local Buffer = require "zion-kit.lib.buffer"
local Window = require "zion-kit.lib.window"

vim.keymap.set("n", "<A-=>", function()
    local buf = Buffer:new()
    local win = Window:new({
        bufnr = buf.bufnr,
        open_window_options = {
            width = 30,
            height = 10,
        },
    })
    buf:set_content({ "look at me" })

    local buf2 = Buffer:new()
    local win2 = Window:new({
        bufnr = buf2.bufnr,
        open_window_options = {
            relative = "editor",
            width = 20,
            height = 10,
        },
    })
    buf2:set_content({ "look at me now" })
end, {})

vim.keymap.set("n", "<A-BS>", function()
    ---@diagnostic disable-next-line: undefined-global
    R "zion-kit"
    ---@diagnostic disable-next-line: undefined-global
    N "zion-kit reloaded"
end, {})

return M
