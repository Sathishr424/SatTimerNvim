local M = {}
local state = require("sattimer.state")
local utils = require("sattimer.utils")
local constants = require("sattimer.constants")

function M.reposition(win, width)
	vim.api.nvim_win_set_config(win, {
		relative = "editor",
		row = 1,
		col = vim.o.columns - width - 2,
	})
end

function M.stopCountDown()
  if not state.running then
    return vim.notify("Count down not running!")
  end

  if state.timer then
    state.timer:stop()
    state.timer:close()
  end

  if state.autocmd then
    vim.api.nvim_del_autocmd(state.autocmd)
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end

  state.running = false
  state.buf = nil
  state.win = nil
  state.timer = nil
  state.autocmd = nil
end

function M.startCountDown(seconds)
	state.running = true
	state.buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {
		"Timer",
		"",
		utils.convertSecondsToString(seconds),
	})

	state.win = vim.api.nvim_open_win(state.buf, false, {
		relative = "editor",
		width = constants.width,
		height = constants.height,
		row = 1,
		col = vim.o.columns - constants.width - 2,
		style = "minimal",
		border = "rounded",
		focusable = false,
		zindex = 200,
	})

	state.autocmd = vim.api.nvim_create_autocmd("VimResized", {
		callback = function()
			M.reposition(state.win, constants.width)
		end,
	})

	state.timer = vim.uv.new_timer()
	state.timer:start(
		1000, -- initial delay
		1000, -- repeat every second
		vim.schedule_wrap(function()
			seconds = seconds - 1

			vim.api.nvim_buf_set_lines(state.buf, 2, 3, false, {
				utils.convertSecondsToString(seconds),
			})

			if seconds <= 0 then
				M.stopCountDown()
			end
		end)
	)
end

return M
