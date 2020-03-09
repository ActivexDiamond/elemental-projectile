return function(t)
	local self = {}
	self.TYPE =  g.type("Stat")
	
	self.max = t.max or 100
	self.min = t.min or 0
	self.cur = t.cur or self.max
	
	self.coolMax = t.coolMax or self.max * 0.25
	self.coolMin = t.coolMin or self.max * 0.10
	
	self.regenFreq = t.regenFreq or -1
	self.regen = t.regen or 0 --self.max * 0.01
	
	self.lastRegen = 0
	self.cooling = false
	
	function self:tick(dt)
		if self.regenFreq > 0 then 									---regen per freq
			if love.timer.getTime() - self.lastRegen >= self.regenFreq then
				self:add(self.regen)
				self.lastRegen = love.timer.getTime()
			end
		elseif self.regenFreq == -1 and self.regen ~= 0 then 		---regen per tick
			self:add(self.regen * dt)
		end
		---cooldown
		if self.cur < self.coolMin then
			self.cooling = true
		elseif self.cur > self.coolMax then
			self.cooling = false
		end
	end
	
	function self:draw(g2d, line, name, col)
		g2d.setColor(col or {1, 1, 1, 1})
		local title = name and name .. ": " or ""
		local str = string.format("%s %d/%d", title, self.cur, self.max)
		g2d.print(str, 20, line * 20)
	end

	function self:add(n)
		if self.cur == self.max then return nil end
		local dif = self.max - self.cur
		dif = n <= dif and n or dif
		self.cur = self.cur + dif
		return dif
	end
	
	function self:rem(n)
		if self.cooling then return nil end
		if self.cur == self.min then return nil end
		local dif = self.cur - self.min
		dif = n <= dif and n or dif
		self.cur = self.cur - dif
		return dif
	end
	
	function self:cap() return self.max - self.cur end
	function self:full() return self.cur == self.max end
	function self:empty() return self.cur == self.min end
	
	return self
end