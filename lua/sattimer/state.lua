---@enum TimerType
local TimerType = {
	TIMER = "timer",
	STOPWATCH = "stopwatch",
}

---@alias Buffer integer
---@alias Window integer

---@class TimerState
---@field type TimerType
---@field running boolean
---@field row integer
---@field buf Buffer?
---@field win Window?
---@field timer uv_timer_t?
---@field autocmd integer?

local M = {
	---@type table<string, TimerState>
	states = {},
}

function M.size()
	local count = 0
	for _ in pairs(M.states) do
		count = count + 1
	end
	return count
end

---@param type TimerType
---@param title string
function M.addNewState(type, title)
	if M.titleExists(title) then
		return false
	end
	M.states[title] = {
		buf = nil,
		win = nil,
		type = type,
		timer = nil,
		row = #M.states + 1,
		autocmd = nil,
		running = false,
	}
	return true
end

function M.titleExists(title)
	if M.states[title] then
		return true
	end
	return false
end

return M
