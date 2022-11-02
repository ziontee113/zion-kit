local Buffer = {
	buffer_options = {
		filetype = "",
		bufhidden = "delete",
	},
}
Buffer.__index = {}

function Buffer:new(user_options)
	local buffer_instance = setmetatable({}, Buffer)

	self:create_scratch_buffer()
	self:extend_buffer_options(user_options.buffer_options)
	self:set_buffer_options()

	return buffer_instance
end

function Buffer:create_scratch_buffer()
	self.bufnr = vim.api.nvim_create_buf(false, true)
end

function Buffer:extend_buffer_options(buffer_options)
	self.buffer_options = vim.tbl_extend("force", self.buffer_options, buffer_options or {})
end

function Buffer:set_buffer_options()
	for option_key, option_value in pairs(self.buffer_options) do
		vim.api.nvim_buf_set_option(self.bufnr, option_key, option_value)
	end
end

function Buffer:set_single_option(option_name, option_value)
	local ok, _ = pcall(vim.api.nvim_buf_set_option, self.bufnr, option_name, option_value)
	self.notify_set_option_failure(ok, option_name, option_value)
end

function Buffer.notify_set_option_failure(ok, option_name, option_value)
	if not ok then
		local error_log_level = 2
		vim.notify({ "Failed to set buffer option: " .. option_name .. "" .. option_value, error_log_level })
	end
end

return Buffer
