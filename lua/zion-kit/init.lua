local M = {}
local Buffer = require "zion-kit.lib.buffer"
local Window = require "zion-kit.lib.window"

vim.keymap.set("n", "<A-=>", function()
    local buf = Buffer:new()
    local win = Window:new({
        bufnr = buf.bufnr,
        open_window_options = {
            width = 10,
            height = 25,
        },
    })
end, {})

vim.keymap.set("n", "<A-BS>", function()
    ---@diagnostic disable-next-line: undefined-global
    R "zion-kit"
    ---@diagnostic disable-next-line: undefined-global
    N "zion-kit reloaded"
end, {})

return M
