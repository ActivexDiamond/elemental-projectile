return function(data, x, y, xDir, yDir)
	local self = {}
	self.TYPE = g.type("Prj", data.type)
	self.ID = data.id

	self.x, self.y = x, y
	self.xDir, self.yDir = xDir, yDir

	self.w, self.h = data.r, data.r
	self.color = data.color

	self.dmtg = data.dmg
	self.speed = data.speed

	self.element = data.element
	self.factors = data.factors
	self.effect = data.effect

	function self:tick(dt)
		---move
		--print(self.x, self.y, self.w, self.h, sw, sh)
		self.x = self.x + self.speed * dt * self.xDir
		self.y = self.y + self.speed * dt * self.yDir
		---exit screen
		if self.x < -self.w or self.x > sw or
				self.y < -self.h or self.y > sh then
			g.world:remove(self)
		end
	end

	function self:draw(g2d)
		---draw self
		g2d.setColor(self.color)
		g2d.rectangle('fill', self.x, self.y, self.w, self.h)
	end

	g.world:add(self)
	return self
end
