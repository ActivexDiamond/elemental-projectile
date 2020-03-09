return function(...)
	local self = {}
	self.types = {...}
	table.insert(self.types, 1, "Object")
	
	function self:is(typ)
		for k, this in ipairs(self.types) do
			if this == typ then return true end
		end
		return false
	end
	
	return self
end