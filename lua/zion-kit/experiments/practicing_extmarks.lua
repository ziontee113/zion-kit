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

-- Data Structure -------------------------------------------------------

local FlowSik = {
    -- stylua: ignore
    labels = {
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ",", ";", "!",
        -- "/", ".", ":", "'", '"', "\\", "=", "-", "_", "[", "]", "{", "}",
    },
    query = nil,
    lang = nil,
    normal_hl_group = nil,
    visual_hl_group = nil,
    namespace = nil,
    nodes = {},
    extmarks = {},
}
FlowSik.__index = FlowSik

function FlowSik:new(props)
    local instance = setmetatable({}, FlowSik)

    for key, prop in pairs(props) do
        self[key] = prop
    end

    return instance
end

function FlowSik:parse_query()
    local iter_query = vim.treesitter.query.parse_query("lua", self.query)

    local parser = vim.treesitter.get_parser(0, self.lang)
    local trees = parser:parse()
    local root = trees[1]:root()

    return iter_query, root
end

function FlowSik:collect_nodes_from_parsed_query()
    local iter_query, root = self:parse_query()

    for _, matches, _ in iter_query:iter_matches(root, 0) do
        local node = matches[1]
        table.insert(self.nodes, node)
    end
end

function FlowSik:create_labels()
    self:collect_nodes_from_parsed_query()

    self.label_set = 1
    local set_index = 1
    for _, node in ipairs(self.nodes) do
        if set_index > #self.labels then
            self.label_set = self.label_set + 1
            set_index = 1
        end

        self:add_label(node, set_index, self.normal_hl_group)

        set_index = set_index + 1
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

            local index_in_labels = self:labels_contains(key)

            if index_in_labels then
                local node_index = index_in_labels * self.label_set
                vim.api.nvim_buf_del_extmark(
                    0,
                    self.namespace,
                    self.extmarks[node_index]
                )

                local node = self.nodes[node_index]
                self:highlight_node(node, node_index, self.visual_hl_group)

                vim.cmd "redraw"
            end
        else
            break
        end
    end
end

function FlowSik:labels_contains(key)
    for i, label in ipairs(self.labels) do
        if label == key then return i end
    end
    return nil
end

function FlowSik:add_label(node, label_index, hl_group)
    local start_row, start_col, _, _ = node:range()
    local extmark_id =
        vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
            virt_text = {
                { self.labels[label_index], hl_group },
            },
            virt_text_pos = "overlay",
            priority = 100,
        })
    table.insert(self.extmarks, extmark_id)
end

function FlowSik:highlight_node(node, label_index, hl_group)
    local start_row, start_col, end_row, end_col = node:range()
    local extmark_id =
        vim.api.nvim_buf_set_extmark(0, ns, start_row, start_col, {
            end_row = end_row,
            end_col = end_col,
            hl_group = "Visual",
            hl_mode = "replace",
            priority = 500,
            virt_text = { { self.labels[label_index], hl_group } },
            virt_text_pos = "overlay",
        })
    table.insert(self.extmarks, extmark_id)
end

-- Getting Nodes --------------------------------------------------------

vim.keymap.set("n", "<leader>k", function()
    local instance = FlowSik:new({
        normal_hl_group = "GruvboxAquaBold",
        visual_hl_group = "AquaVisual",
        namespace = ns,
        lang = "lua",
        query = [[
            ;; query
            ( "string_content" @cap (#visible-in-view? @cap) )
        ]],
    })

    instance:create_labels()
end)

-- Mappings -------------------------------------------------------------

vim.keymap.set("n", "<leader>c", function()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end)

-- {{{nvim-execute-on-save}}}
