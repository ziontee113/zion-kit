require "zion-kit.experiments.ts_node_in_range_predicates"
local ts_utils = require "nvim-treesitter.ts_utils"

local function get_iter_query_and_root(lang, query)
    local iter_query = vim.treesitter.query.parse_query(lang, query)

    local parser = vim.treesitter.get_parser(0, lang)
    local trees = parser:parse()
    local root = trees[1]:root()
    return iter_query, root
end

local function update_selection(direction, iter_query, root)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_row = cursor[1] - 1
    local cursor_col = cursor[2]

    if direction == "forward" then
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
    end

    if direction == "backwards" then
        local nodes = {}
        for _, matches, _ in iter_query:iter_matches(root, 0) do
            local node = matches[1]
            table.insert(nodes, node)
        end

        for i = #nodes, 1, -1 do
            local node = nodes[i]
            local start_row, start_col, _, _ = node:range()

            if start_row == cursor_row and start_col < cursor_col then
                ts_utils.update_selection(0, node, "v")
                vim.cmd "norm! o"
                break
            end

            if start_row < cursor_row then
                ts_utils.update_selection(0, node, "v")
                vim.cmd "norm! o"
                break
            end
        end
    end
end

local function node_movement(opts)
    local iter_query, root = get_iter_query_and_root(opts.lang, opts.query)
    update_selection(opts.direction, iter_query, root)
end

vim.keymap.set({ "n", "x" }, "<leader>j", function()
    node_movement({
        direction = "forward",
        lang = "lua",
        query = [[
            ;; query
            ( "string_content" @cap (#visible-in-view? @cap) )
        ]],
    })
end, {})
vim.keymap.set({ "n", "x" }, "<leader>k", function()
    node_movement({
        direction = "backwards",
        lang = "lua",
        query = [[
            ;; query
            ( "string_content" @cap (#visible-in-view? @cap) )
        ]],
    })
end, {})

-- {{{nvim-execute-on-save}}}
