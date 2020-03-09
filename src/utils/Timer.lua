local class = require "libs.cruxclass"

local Timer = class("Timer")
function Timer:init()
	self.funcs, self.times, self.cleanup = {}, {}, {}
end

function Timer:tick(dt)
	if #self.funcs > 0 then
		for k, f in ipairs(self.funcs) do
			self.times[k] = self.times[k] - dt
			if self.times[k] <= 0 then 
				self.cleanup[k]()
				table.remove(self.funcs, k)
				table.remove(self.times, k)
				table.remove(self.cleanup, k)
			else f() end
		end
	end
end

function Timer:callFor(obj, sec, func, cleanup)
	local i = false;
	for k, v in ipairs(self.funcs) do
		if v == func then i = k end
	end
	if not i then 
		table.insert(self.funcs, func)
		table.insert(self.times, sec)
		table.insert(self.cleanup, cleanup or function() end)
	end
end

return Timer