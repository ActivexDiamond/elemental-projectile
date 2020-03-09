return function(id, x, y, r, dmg)
	local self = {}
	self.TYPE = g.type("Prj", "PlayerPrj")
	self.ID = id
	
	self.x, self.y = x, y
	self.w, self.h, self.dmg = r, r, dmg	
	
	self.color = {0, 0, 1, 1}

	self.dmg = 5
	self.velX, self.velY = 0, 0	

	function self:tick(dt)
		---move
		self.x = self.x + self.velX
		self.y = self.y + self.velY
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
	
	function self:setVel(x, y)
		self.velX = x
		self.velY = y
	end
	
	return self
end