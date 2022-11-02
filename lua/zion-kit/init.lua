local M = {}
local Window = require "zion-kit.lib.window"

vim.keymap.set("n", "<A-=>", function()
    local win = Window:new()
    win:open()
end, {})

vim.keymap.set("n", "<A-BS>", function()
    ---@diagnostic disable-next-line: undefined-global
    R "zion-kit"
    ---@diagnostic disable-next-line: undefined-global
    N "zion-kit reloaded"
end, {})

return M
