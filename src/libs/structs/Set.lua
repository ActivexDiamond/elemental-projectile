return function(...)		-- Set()
	local self = {...}
	
	function self.add(o) 
		if self.contains(o) then return end
		table.insert(self, o) 
	end
	
	function self.remove(o) 
		for k, v in ipairs(self) do
			if v == o then 
				table.remove(self, k) 
				return o
			end
		end
	end
	
	function self.contains(o)
		for k, v in ipairs(self) do
			if v == o or (v.equals and v.equals(o)) then 
				return true end
		end	
		return false
	end
	
	return self
end
