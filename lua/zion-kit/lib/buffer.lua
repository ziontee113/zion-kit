local Buffer = {
    buffer_options = {
        filetype = "",
        bufhidden = "delete",
    },
}

function Buffer:new(user_options)
    local buffer_instance = setmetatable({}, { __index = Buffer })

    user_options = user_options or {}

    buffer_instance:create_scratch_buffer()
    buffer_instance:extend_buffer_options(user_options.buffer_options)
    buffer_instance:set_buffer_options()

    return buffer_instance
end

function Buffer:set_content(content_tbl)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, content_tbl)
end

function Buffer:create_scratch_buffer()
    self.bufnr = vim.api.nvim_create_buf(false, true)
end

function Buffer:extend_buffer_options(buffer_options)
    self.buffer_options =
        vim.tbl_extend("force", self.buffer_options, buffer_options or {})
end

function Buffer:set_buffer_options()
    for option_name, option_value in pairs(self.buffer_options) do
        local ok, _ = pcall(
            vim.api.nvim_buf_set_option,
            self.bufnr,
            option_name,
            option_value
        )
        self.notify_buf_set_option_failure(ok, option_name, option_value)
    end
end

function Buffer:set_single_option(option_name, option_value)
    local ok, _ = pcall(
        vim.api.nvim_buf_set_option,
        self.bufnr,
        option_name,
        option_value
    )
    self.notify_buf_set_option_failure(ok, option_name, option_value)
end

function Buffer.notify_buf_set_option_failure(ok, option_name, option_value)
    if not ok then
        vim.notify({
            "Failed to set Buffer option: "
                .. option_name
                .. " :: "
                .. tostring(option_value),
        }, "error")
    end
end

return Buffer
