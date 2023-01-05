local Window = {
    open_window_options = {
        relative = "cursor",
        col = 0,
        row = 0,
        style = "minimal",
        border = "single",
        width = 25,
        height = 10,
    },
    window_options = {
        --
    },
}
Window.__index = Window

function Window:new(options)
    if Window.options_are_valid(options) then
        local window_instance = setmetatable({}, Window)

        window_instance:extend_open_window_options(options.open_window_options)
        window_instance:extend_window_options(options.window_options)
        window_instance:open(options.bufnr)
        window_instance:set_window_options()

        return window_instance
    end
end

function Window.options_are_valid(options)
    return options.bufnr
end

---@param position table|nil
function Window:jump_to(position)
    position = position or { 1, 0 }
    vim.api.nvim_win_set_cursor(self.winnr, position)
    vim.api.nvim_set_current_win(self.winnr)
end

function Window:close()
    vim.api.nvim_win_close(self.winnr, true)
end

function Window:extend_open_window_options(user_open_window_options)
    self.open_window_options = vim.tbl_extend(
        "force",
        self.open_window_options,
        user_open_window_options or {}
    )
end

function Window:extend_window_options(user_window_options)
    self.window_options =
        vim.tbl_extend("force", self.window_options, user_window_options or {})
end

function Window:set_window_options()
    for option_name, option_value in pairs(self.window_options) do
        self:set_single_option(option_name, option_value)
    end
end

function Window:set_single_option(option_name, option_value)
    local ok, _ = pcall(
        vim.api.nvim_win_set_option,
        self.winnr,
        option_name,
        option_value
    )
    self.notify_win_set_option_failure(ok, option_name, option_value)
end

function Window.notify_win_set_option_failure(ok, option_name, option_value)
    if not ok then
        vim.notify({
            "Failed to set Window option: "
                .. option_name
                .. " = "
                .. tostring(option_value),
        }, "error")
    end
end

function Window:get_editor_width_and_height()
    local editorStats = vim.api.nvim_list_uis()[1]
    self.editorStats = {
        editorWidth = editorStats.width,
        editorHeight = editorStats.height,
    }
end

function Window:open(bufnr)
    self.winnr = vim.api.nvim_open_win(bufnr, true, self.open_window_options)
end

return Window
