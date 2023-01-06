require "zion-kit.experiments.ts_node_in_range_predicates"

local ns = vim.api.nvim_create_namespace "ts_testing"

local combine_hl_groups =
    function(fg_group, bg_group, output_group_name, output_group_properties)
        local foreground_rgb =
            vim.api.nvim_get_hl_by_name(fg_group, true).foreground
        local foreground_hex = string.format("#%06x", foreground_rgb)

        local background_rgb =
            vim.api.nvim_get_hl_by_name(bg_group, true).background
        local background_hex = string.format("#%06x", background_rgb)

        output_group_properties = output_group_properties
        output_group_properties.fg = foreground_hex
        output_group_properties.bg = background_hex

        vim.api.nvim_set_hl(0, output_group_name, output_group_properties)
        return output_group_name
    end

combine_hl_groups("GruvboxAqua", "Visual", "AquaVisual", {
    bold = true,
})

-- Getting Nodes --------------------------------------------------------

REMAP("n", "<Plug>L1 G, R1 P<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    vim.cmd "messages clear"

    local query = [[
        ;; query
        ( "string_content" @cap (#visible-in-view? @cap) )
    ]]

    -- local query = [[
    --     ;; query
    --     ( (variable_declaration) @cap (#visible-in-view? @cap) )
    -- ]]

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
        -- "/", ".", ":", "'", '"', "\\", "=", "-", "_", "[", "]", "{", "}",
    }

    local hash_table = {}
    local extmark_hash_table = {}
    local count = 1
    for _, matches, _ in iter_query:iter_matches(root, 0) do
        if labels[count] then
            local node = matches[1]

            local start_row, start_col, end_row, end_col = node:range()
            local extmark_id =
                vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
                    virt_text = { { labels[count], "GruvboxOrangeBold" } },
                    virt_text_pos = "overlay",
                })

            hash_table[labels[count]] = node
            extmark_hash_table[labels[count]] = extmark_id
            count = count + 1
        end
    end

    vim.cmd "redraw"

    while true do
        local ok, keynum = pcall(vim.fn.getchar)
        if ok then
            local key = string.char(keynum)

            if key == "" then
                vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
                break
            end

            local node = hash_table[key]
            if node then
                local start_row, start_col, end_row, end_col = node:range()
                vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
                    end_row = end_row,
                    end_col = end_col,
                    hl_group = "Visual",
                    hl_mode = "replace",
                    priority = 500,
                    virt_text = { { key, "AquaVisual" } },
                    virt_text_pos = "overlay",
                })

                vim.api.nvim_buf_del_extmark(0, ns, extmark_hash_table[key])
            end

            vim.cmd "redraw"
        end
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
