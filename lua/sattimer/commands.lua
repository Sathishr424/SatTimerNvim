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
		local args = vim.split(opts.args, "%s+")
		if #args == 0 then
			return ui.notify("You should pass atleast duration of the Timer")
		end

		local duration = args[1]
		local title = args[2] or ("Timer " .. (state.size() + 1))

		M.countDown(duration, title)
	end, {
		nargs = 1,
	})
	vim.api.nvim_create_user_command("StopTimer", function(opts)
		M.stopCountDown(opts.args)
	end, {
		nargs = 1,
	})

	vim.api.nvim_create_user_command("Stopwatch", function(opts)
    local title = opts.args
    if title == "" then
      title = "Stopwatch " .. (state.size() + 1)
    end
		M.startStopWatch(title)
	end, {
		nargs = "?",
	})
	vim.api.nvim_create_user_command("StopStopwatch", function(opts)
		M.stopStopWatch(opts.args)
	end, { nargs = 1 })
end

--- @param duration string
--- @param title string
function M.countDown(duration, title)
	local seconds = utils.parseDurationString(duration)
	if seconds == -1 then
		return ui.notify("Not a valid timer duration")
	end

	ui.startCountDown(seconds, title)
end

function M.stopCountDown(title)
	ui.stopTimer(title)
end

function M.startStopWatch(title)
	ui.startStopWatch(title)
end

function M.stopStopWatch(title)
	ui.stopTimer(title)
end

return M
