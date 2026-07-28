local M = {}
local state = require("sattimer.state")
local utils = require("sattimer.utils")
local ui = require("sattimer.ui")

function M.setup()
  -- vim.keymap.set("n", "<C-t>", function()
  --   if state.timer.running then
  --     M.stopCountDown()
  --   else
  --     M.countDown("20s")
  --   end
  -- end)

	-- vim.api.nvim_create_user_command("ReloadMyPlugin", function()
	-- 	for name, _ in pairs(package.loaded) do
	-- 		if name:match("^myplugin") then
	-- 			package.loaded[name] = nil
	-- 		end
	-- 	end
	--
	-- 	vim.notify("Plugin reloaded")
	-- end, {})

	vim.api.nvim_create_user_command("Timer", function(opts)
		M.countDown(opts.args)
	end, {
		nargs = 1,
	})
	vim.api.nvim_create_user_command("StopTimer", function()
		M.stopCountDown()
	end, {})

	vim.api.nvim_create_user_command("Stopwatch", function()
		M.startStopWatch()
	end, {})
	vim.api.nvim_create_user_command("StopStopwatch", function()
		M.stopStopWatch()
	end, {})
end

--- @param args string
function M.countDown(args)
	if state.timer.running then
		return vim.notify("Another timer is already running, wait for it to finish or stop it using :StopCountDown")
	end

	local seconds = utils.parseDurationString(args)
	if seconds == -1 then
		vim.notify("Not a valid timer duration")
		return
	end

  ui.startCountDown(seconds)
end

function M.stopCountDown()
  ui.stopTimer("timer")
end


function M.startStopWatch()
	if state.stopwatch.running then
		return vim.notify("Another stopwatch is already running, Close it before starting a new one using :StopStopWatch")
	end

  ui.startStopWatch()
end

function M.stopStopWatch()
  ui.stopTimer("stopwatch")
end

return M
