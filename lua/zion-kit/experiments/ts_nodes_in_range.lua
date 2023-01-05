local query = require "vim.treesitter.query"

local function valid_args(name, pred, count, strict_count)
    local arg_count = #pred - 1

    if strict_count then
        if arg_count ~= count then
            error(
                string.format("%s must have exactly %d arguments", name, count)
            )
            return false
        end
    elseif arg_count < count then
        error(string.format("%s must have at least %d arguments", name, count))
        return false
    end

    return true
end

---@diagnostic disable-next-line: unused-local
query.add_predicate("in-range?", function(match, _pattern, _bufnr, pred)
    if not valid_args("in-range?", pred, 3, true) then return end

    local node = match[pred[2]]
    local start_row, _, end_row, _ = node:range()

    local top_limit = tonumber(pred[3]) - 1
    local bottom_limit = tonumber(pred[4]) - 1

    if top_limit <= start_row and bottom_limit >= end_row then return true end

    return false
end)
