local M = {}
local state = require("sattimer.state")
local utils = require("sattimer.utils")
local constants = require("sattimer.constants")

---@param message string
---@param title? string
---@param timeout? integer -- milliseconds
function M.notify(message, title, timeout)
    title = title or "SatTimer"
    timeout = timeout or 3000

    local lines = vim.split(message, "\n", { plain = true })

    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    local height = #lines

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win = vim.api.nvim_open_win(buf, false, {
        relative = "editor",
        width = width,
        height = height,
        row = 1,
        col = vim.o.columns - width - 1,
        style = "minimal",
        border = "rounded",
        title = " " .. title .. " ",
        title_pos = "center",
        focusable = false,
        zindex = 1000,
        noautocmd = true,
    })

    local timer = vim.uv.new_timer()
    timer:start(timeout, 0, vim.schedule_wrap(function()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        timer:stop()
        timer:close()
    end))
end

function M.reposition(title)
	vim.api.nvim_win_set_config(state.states[title].win, {
		relative = "editor",
		row = (state.states[title].row - 1) * constants.height * 2 + 1,
		col = vim.o.columns - constants.width - 2,
	})
end

function M.stopTimer(title)
	if not state.titleExists(title) then
		return M.notify("No stopwatch or timer exists with the given title")
	end

	if state.states[title].timer then
		state.states[title].timer:stop()
		state.states[title].timer:close()
	end

	if state.states[title].autocmd then
		vim.api.nvim_del_autocmd(state.states[title].autocmd)
	end

	if state.states[title].win and vim.api.nvim_win_is_valid(state.states[title].win) then
		vim.api.nvim_win_close(state.states[title].win, true)
	end

	if state.states[title].buf and vim.api.nvim_buf_is_valid(state.states[title].buf) then
		vim.api.nvim_buf_delete(state.states[title].buf, { force = true })
	end

	state.states[title].buf = nil
	state.states[title].win = nil
	state.states[title].timer = nil
	state.states[title].autocmd = nil

	local lastRow = state.states[title].row
	state.states[title] = nil

	for key, _ in pairs(state.states) do
		if state.states[key].row > lastRow then
			state.states[key].row = state.states[key].row - 1
			M.reposition(key)
		end
	end
end

local function createWindow(type, seconds, title)
	local name = (type == "timer") and "Timer" or "Stopwatch"
	local row = state.size()
	state.states[title].row = row

	vim.api.nvim_buf_set_lines(state.states[title].buf, 0, -1, false, {
		name,
		utils.convertSecondsToString(seconds),
	})

	state.states[title].win = vim.api.nvim_open_win(state.states[title].buf, false, {
		relative = "editor",
		width = constants.width,
		height = constants.height,
		row = (state.states[title].row - 1) * constants.height * 2 + 1,
		col = vim.o.columns - constants.width - 1,
		style = "minimal",
		border = "rounded",
		focusable = false,
		zindex = 200,
		title = " " .. title .. " ",
		title_pos = "center", -- "left", "center", or "right"
	})

	state.states[title].autocmd = vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			M.reposition(type)
		end,
	})
end

function M.startCountDown(seconds, title)
	if not state.addNewState("timer", title) then
		return M.notify("Timer with this title already exists...")
	end
	local currState = state.states[title]

	currState.running = true
	currState.buf = vim.api.nvim_create_buf(false, true)

	createWindow("timer", seconds, title)

	currState.timer = vim.uv.new_timer()
	currState.timer:start(
		1000, -- initial delay
		1000, -- repeat every second
		vim.schedule_wrap(function()
			seconds = seconds - 1

			vim.api.nvim_buf_set_lines(currState.buf, 1, 2, false, {
				utils.convertSecondsToString(seconds),
			})

			if seconds <= 0 then
				M.stopTimer(title)
				M.notify("Your countdown finished!", "⏰ " .. title)
			end
		end)
	)
end

function M.startStopWatch(title)
	if not state.addNewState("stopwatch", title) then
		return M.notify("Stopwatch with this title already exists...")
	end
	local currState = state.states[title]

	currState.running = true
	currState.buf = vim.api.nvim_create_buf(false, true)

	createWindow("stopwatch", 0, title)

	local seconds = 0

	currState.timer = vim.uv.new_timer()
	currState.timer:start(
		1000, -- initial delay
		1000, -- repeat every second
		vim.schedule_wrap(function()
			seconds = seconds + 1

			vim.api.nvim_buf_set_lines(currState.buf, 1, 2, false, {
				utils.convertSecondsToString(seconds),
			})
		end)
	)
end

return M
