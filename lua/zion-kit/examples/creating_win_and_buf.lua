local Buffer = require "zion-kit.lib.Buffer"
local Window = require "zion-kit.lib.Window"

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

    vim.keymap.set("n", "q", function()
        win:close()
    end, { buffer = buf.bufnr })
end, {})
