local M = {}
local state = require("sattimer.state")
local utils = require("sattimer.utils")
local constants = require("sattimer.constants")

function M.reposition(type)
	vim.api.nvim_win_set_config(state[type].win, {
		relative = "editor",
		row = state[type].row,
		col = vim.o.columns - constants.width - 2,
	})
end

function M.stopTimer(type)
  local oppositeName = (type == "timer") and "stopwatch" or "timer"
  if not state[type].running then
    if type == "timer" then
      vim.notify("Timer not running...")
    elseif type == "stopwatch" then
      vim.notify("Stopwatch not running...")
    end
    return
  end

  if state[type].timer then
    state[type].timer:stop()
    state[type].timer:close()
  end

  if state[type].autocmd then
    vim.api.nvim_del_autocmd(state[type].autocmd)
  end

  if state[type].win and vim.api.nvim_win_is_valid(state[type].win) then
    vim.api.nvim_win_close(state[type].win, true)
  end

  if state[type].buf and vim.api.nvim_buf_is_valid(state[type].buf) then
    vim.api.nvim_buf_delete(state[type].buf, { force = true })
  end

  state[type].running = false
  state[type].buf = nil
  state[type].win = nil
  state[type].timer = nil
  state[type].autocmd = nil

  if state[oppositeName].running then
    state[oppositeName].row = 1
    M.reposition(oppositeName)
  end
end

local function createWindow(type, seconds)
  local name = (type == "timer") and "Timer" or "Stopwatch"
  local oppositeName = (type == "timer") and "stopwatch" or "timer"

	vim.api.nvim_buf_set_lines(state[type].buf, 0, -1, false, {
		name,
		utils.convertSecondsToString(seconds),
	})

  local row = 1
  if state[oppositeName].running then
    row = row + constants.height * 2
  end
  state[type].row = row

	state[type].win = vim.api.nvim_open_win(state[type].buf, false, {
		relative = "editor",
		width = constants.width,
		height = constants.height,
		row = row,
		col = vim.o.columns - constants.width - 1,
		style = "minimal",
		border = "rounded",
		focusable = false,
		zindex = 200,
	})

	state[type].autocmd = vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			M.reposition(type)
		end,
	})
end

function M.startCountDown(seconds)
	state.timer.running = true
	state.timer.buf = vim.api.nvim_create_buf(false, true)

  createWindow("timer", seconds)

	state.timer.timer = vim.uv.new_timer()
	state.timer.timer:start(
		1000, -- initial delay
		1000, -- repeat every second
		vim.schedule_wrap(function()
			seconds = seconds - 1

			vim.api.nvim_buf_set_lines(state.timer.buf, 1, 2, false, {
				utils.convertSecondsToString(seconds),
			})

			if seconds <= 0 then
				M.stopTimer("timer")
        vim.notify("Your count down finished!!")
			end
		end)
	)
end

function M.startStopWatch()
	state.stopwatch.running = true
	state.stopwatch.buf = vim.api.nvim_create_buf(false, true)

  createWindow("stopwatch", 0)

  local seconds = 0

	state.stopwatch.timer = vim.uv.new_timer()
	state.stopwatch.timer:start(
		1000, -- initial delay
		1000, -- repeat every second
		vim.schedule_wrap(function()
			seconds = seconds + 1

			vim.api.nvim_buf_set_lines(state.stopwatch.buf, 1, 2, false, {
				utils.convertSecondsToString(seconds),
			})
		end)
	)
end

return M
