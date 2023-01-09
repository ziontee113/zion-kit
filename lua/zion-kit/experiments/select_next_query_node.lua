require "zion-kit.experiments.ts_node_in_range_predicates"
local ts_utils = require "nvim-treesitter.ts_utils"

vim.keymap.set({ "n", "x" }, "<leader>k", function()
    local lang = "lua"
    local query = [[
        ;; query
        ( "string_content" @cap (#visible-in-view? @cap) )
    ]]

    local iter_query = vim.treesitter.query.parse_query(lang, query)

    local parser = vim.treesitter.get_parser(0, lang)
    local trees = parser:parse()
    local root = trees[1]:root()

    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
    local cursor_col = vim.api.nvim_win_get_cursor(0)[2]

    for _, matches, _ in iter_query:iter_matches(root, 0) do
        local node = matches[1]
        local node_row, node_col, _, _ = node:range()

        if node_row == cursor_row and node_col > cursor_col then
            ts_utils.update_selection(0, node, "v")
            break
        end

        if node_row > cursor_row then
            ts_utils.update_selection(0, node, "v")
            break
        end
    end
end, {})

-- {{{nvim-execute-on-save}}}
