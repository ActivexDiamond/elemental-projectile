return function()
	local self = {}
	self.x, self.y = 0, 0
	self.w, self.h = 32, 32
	self.color = {1, .5, 1, 1}
	
	function self:tick(dt)
	
	end
	
	function self:draw(g)
		g.setColor(self.color)
		g.rectangle('fill', self.x, self.y, self.w, self.h)
	end
	
	return self
end