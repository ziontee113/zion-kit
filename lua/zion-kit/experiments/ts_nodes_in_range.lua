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

------------------------------------------------------------------------------ In Range

query.add_predicate("fits-in-range?", function(match, _, _, pred)
    if not valid_args("fits-in-range?", pred, 3, true) then return end

    local node = match[pred[2]]
    local start_row, _, end_row, _ = node:range()

    local top_limit = tonumber(pred[3]) - 1
    local bottom_limit = tonumber(pred[4]) - 1

    if top_limit <= start_row and bottom_limit >= end_row then return true end

    return false
end)

query.add_predicate("visible-in-range?", function(match, _, _, pred)
    if not valid_args("visible-in-range?", pred, 3, true) then return end

    local node = match[pred[2]]
    local start_row, _, end_row, _ = node:range()

    local top_limit = tonumber(pred[3]) - 1
    local bottom_limit = tonumber(pred[4]) - 1

    if top_limit <= start_row and bottom_limit >= end_row then return true end
    if top_limit <= start_row and bottom_limit >= start_row then return true end
    if top_limit <= end_row and bottom_limit >= end_row then return true end

    return false
end)

------------------------------------------------------------------------------ In View

query.add_predicate("fits-in-view?", function(match, _, _, pred)
    if not valid_args("fits-in-view?", pred, 1, true) then return end

    local node = match[pred[2]]
    local start_row, _, end_row, _ = node:range()

    local first_line, last_line =
        tonumber(vim.fn.line "w0"), tonumber(vim.fn.line "w$")

    if first_line <= start_row and last_line >= end_row then return true end

    return false
end)

query.add_predicate("visible-in-view?", function(match, _, _, pred)
    if not valid_args("visible-in-view?", pred, 1, true) then return end

    local node = match[pred[2]]
    local start_row, _, end_row, _ = node:range()

    local first_line, last_line =
        tonumber(vim.fn.line "w0"), tonumber(vim.fn.line "w$")

    if first_line <= start_row and last_line >= end_row then return true end
    if first_line <= start_row and last_line >= start_row then return true end
    if first_line <= end_row and last_line >= end_row then return true end

    return false
end)
