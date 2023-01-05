require "zion-kit.experiments.ts_node_in_range_predicates"

local ns = vim.api.nvim_create_namespace "ts_testing"

-- Getting Nodes --------------------------------------------------------

REMAP("n", "<Plug>R1 P, L1 A<Plug>", function()
    vim.cmd "messages clear"

    local query = [[
        ;; query
        ( (variable_declaration) @cap (#visible-in-view? @cap) )
    ]]
    local iter_query = vim.treesitter.query.parse_query("lua", query)

    local parser = vim.treesitter.get_parser(0, "lua")
    local trees = parser:parse()
    local root = trees[1]:root()

    for _, matches, _ in iter_query:iter_matches(root, 0) do
        local node = matches[1]
        local node_text = vim.treesitter.query.get_node_text(node, 0)
        print(node_text)
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
