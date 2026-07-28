---@alias Buffer integer
---@alias Window integer

---@class TimerState
---@field running boolean
---@field buf Buffer?
---@field win Window?
---@field timer uv_timer_t?
---@field autocmd integer?

---@type TimerState
local M = {
    buf = nil,
    win = nil,
    timer = nil,
    autocmd = nil,
    running = false,
}

return M
