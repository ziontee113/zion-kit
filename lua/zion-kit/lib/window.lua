local Window = {}
Window.__index = Window

function Window:new(options)
	local window_instance = setmetatable({}, Window)

	-- TODO:

	-- nvim_create_buf()
	-- nvim_open_win()

	return window_instance
end

function Window:open(options)
	N("window openened")
end

return Window
