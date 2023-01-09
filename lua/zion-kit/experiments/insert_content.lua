local namespace = vim.api.nvim_create_namespace "ts_testing"

-- TODO: the z a b approach

vim.keymap.set("n", "<Plug>L1 G, R1 P<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)

    vim.api.nvim_buf_set_extmark(0, namespace, 0, 8, {
        virt_text = { { "a", "GruvboxOrangeBold" } },
        virt_text_pos = "overlay",
    })

    vim.api.nvim_buf_set_extmark(0, namespace, 0, 12, {
        virt_text = { { "b", "GruvboxAquaBold" } },
        virt_text_pos = "overlay",
    })
end)

vim.keymap.set("n", "<Plug>L1 G, R1 L<Plug>", function()
    vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end)

-- {{{nvim-execute-on-save}}}
