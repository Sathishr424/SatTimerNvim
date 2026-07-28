local M = {}

function M.parseDurationString(str)
	local n = string.len(str)

	local prev = 0
	local seconds = 0
	for i = 1, n do
		local char = string.sub(str, i, i)

		if char == "s" then
			seconds = seconds + prev
			prev = 0
		elseif char == "m" then
			seconds = seconds + prev * 60
			prev = 0
		elseif char == "h" then
			seconds = seconds + prev * 60 * 60
			prev = 0
		elseif char == " " then
			goto continue
		elseif char:match("^%d$") then
			prev = prev * 10 + tonumber(char)
		else
			return -1
		end
		::continue::
	end

	return seconds
end

local function padding(num)
	if num < 10 then
		return "0" .. num
	else
		return tostring(num)
	end
end

function M.convertSecondsToString(seconds)
	local hour = math.floor(seconds / (60 * 60))
	local minute = math.floor(seconds / 60) % 60
	seconds = seconds % 60

	local ret = ""
	if hour > 0 then
		ret = ret .. padding(hour) .. ":"
	end
	ret = ret .. padding(minute) .. ":"
	ret = ret .. padding(seconds)

	return ret
end

return M
