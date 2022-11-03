vim.keymap.set({ "n", "x" }, "<A-p>", function()
    local v_line_start, v_col_start = vim.fn.line "v", vim.fn.col "v"
    local v_line_end, v_col_end = vim.fn.line ".", vim.fn.col "."

    local vim_mode = vim.fn.mode()
    N({ vim_mode, { v_line_start, v_col_start }, { v_line_end, v_col_end } })

    local lines =
        vim.api.nvim_buf_get_lines(0, v_line_start - 1, v_line_end, false)

    for _, line in ipairs(lines) do
        N(line)
    end
end, {})

-- {{{nvim-execute-on-save}}}
