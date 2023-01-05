require "zion-kit.experiments.ts_node_in_range_predicates"

local ns = vim.api.nvim_create_namespace "ts_testing"

-- Getting Nodes --------------------------------------------------------

REMAP("n", "<Plug>R1 P, L1 A<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    vim.cmd "messages clear"

    local query = [[
        ;; query
        ( (variable_declaration) @cap (#visible-in-view? @cap) )
    ]]
    local iter_query = vim.treesitter.query.parse_query("lua", query)

    local parser = vim.treesitter.get_parser(0, "lua")
    local trees = parser:parse()
    local root = trees[1]:root()

    -- stylua: ignore
    local labels = {
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ";", "!",
    }

    local count = 1
    for _, matches, _ in iter_query:iter_matches(root, 0) do
        local node = matches[1]

        -- local node_text = vim.treesitter.query.get_node_text(node, 0)
        -- print(node_text)

        local start_row, start_col, end_row, end_col = node:range()
        vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
            virt_text = { { labels[count], "GruvboxAquaBold" } },
            virt_text_pos = "overlay",
        })
        vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
            virt_text = { { "<-- " .. labels[count], "GruvboxAquaBold" } },
            priority = 500,
        })
        count = count + 1
    end
end)

-- Mappings -------------------------------------------------------------

REMAP("n", "<Plug>L1 G, R1 L<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end)

REMAP("n", "<Plug>L1 G, R1 H<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

    vim.api.nvim_buf_set_extmark(0, ns, 3, 0, {
        virt_text = { { "hello", "GruvboxAquaBold" } },
    })
end)

-- {{{nvim-execute-on-save}}}