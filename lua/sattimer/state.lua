---@alias Buffer integer
---@alias Window integer

---@class TimerState
---@field running boolean
---@field row integer
---@field buf Buffer?
---@field win Window?
---@field timer uv_timer_t?
---@field autocmd integer?

---@type table<string, TimerState>
local M = {
	timer = {
		buf = nil,
		win = nil,
		timer = nil,
    row = 1,
		autocmd = nil,
		running = false,
	},
	stopwatch = {
		buf = nil,
		win = nil,
    row = 1,
		timer = nil,
		autocmd = nil,
		running = false,
	},
}

return M
