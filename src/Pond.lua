return function(x, y, w, h, amount)
	local self = {}
	self.TYPE = g.type("Pickup")
	self.ID = "pond"
	self.x, self.y = x, y
	self.w, self.h = w, h
	self.color = {0, 0, 1, .8}
	
	self.amount = amount or 20
	
	function self:tick(dt)

	end
	
	function self:draw(g2d)
		---draw self
		g2d.setColor(self.color)
		g2d.rectangle('fill', self.x, self.y, self.w, self.h)
	end
	
	return self
end