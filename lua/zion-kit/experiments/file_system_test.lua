local uv = vim.loop

local function readFileSync(path)
    local fd = assert(uv.fs_open(path, "r", 438))
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    return data
end

local data =
    readFileSync "/home/ziontee113/.config/nvim-custom-plugin/zion-kit/stylua.toml"
print("synchronous read", data)

local function writeFileSync(path, flag)
    local fd = assert(uv.fs_open(path, flag, 438))

    uv.fs_write(fd, "Hello World\n", -1)
    uv.fs_write(fd, { "with\n", "more\n", "lines\n" }, -1)
    uv.fs_close(fd)
    -- uv.fs_unlink(path) -- this will `remove` the file
end

-- writeFileSync(
--     "/home/ziontee113/.config/nvim-custom-plugin/zion-kit/test.txt",
--     "a"
-- )

-- {{{nvim-execute-on-save}}}
