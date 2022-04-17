
------------------------------ x ------------------------------
------------------------------ x ------------------------------
return function()
	local self = {}
	self.TYPE = g.type("World")
	self.objs = {}
	
	function self:tick(dt)
		for k, obj in ipairs(self.objs) do
			self:checkCollisions(obj)
			if obj.tick then obj:tick(dt) end
		end		
	end
	
	function self:draw(g)
		for k, obj in ipairs(self.objs) do
			if obj.draw then obj:draw(g) end
			if obj.drawGui then obj:drawGui() end
		end
	end


	function self:checkCollisions(this)
		if this.onCollision then
			local colis = self:queryRect(this)
			for k, other in ipairs(colis or {}) do
				this:onCollision(other)
			end
		end
	end
	
	function self:onKeyPressed(k)
		for _, obj in ipairs(self.objs) do
			if obj.onKeyPressed then obj:onKeyPressed(k) end
		end
	end
	
	function self:onKeyReleased(k)
		for _, obj in ipairs(self.objs) do
			if obj.onKeyReleased then obj:onKeyReleased(k) end
		end
	end
	
	function self:add(obj)
		table.insert(self.objs, obj)
	end
		
	function self:remove(obj)
		for k, v in ipairs(self.objs) do
			if v == obj then
				table.remove(self.objs, k)
				return true
			end
		end
		return false
	end
	
	function self:queryRect(x, y, w, h)
		if type(x) == 'table' then
			x, y, w, h = x.x, x.y, x.w, x.h
		end
		
		local rtVal = {}
		for k, obj in ipairs(self.objs) do
			if obj.x and obj.y and obj.w and obj.h and
					self:rectIntersects(x, y, w, h, obj) then
				table.insert(rtVal, obj)
			end
		end
		return #rtVal > 1 and rtVal or nil
	end
	
	function self:rectIntersects(x, y, w, h, o)
		return x < o.x + o.w and 
			y < o.y + o.h and 
			x + w > o.x and
			y + h > o.y
	end
	return self
end