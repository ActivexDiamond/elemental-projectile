local Pond = require "Pond"

return function()
	local self = {}
	self.TYPE = "PondGen"
	self.w, self.h = 32, 32
	
	self.initial = 10
	self.max = 12
	self.respawn = 5
	self.respawnMarginMinus = 2
	self.respawnMarginPlus = 4
	
	self.fluidWeights = {
		water = 4,
		lava = 1,
	}
	
	---Const
	local function init()
		for i = 1, self.initial do self:spawn() end
	end
	
	function self:tick(dt)
		
	end
	
	function self:spawn()
		local x = math.random(0, sw-self.w)
		local y = math.random(0, sh-self.h)
		
		if g.world:queryRect(x, y, self.w, self.h) then
			self:spawn()
		else
			g.world:add( Pond(x, y, self.w, self.h, self:fetchFluidId()) )
			return true
		end
	end

	function self:fetchPonds()
		local rtVal = {}
		for k, v in ipairs(g.world.objs) do
			if v.TYPE and v.TYPE == "Pond" then
				table.insert(rtVal, v)
			end
		end
		return #rtVal > 0 and rtVal or nil
	end
	
	function self:fetchFluidId()
		local rw = {}
		for k, v in pairs(self.fluidWeights) do
			for i = 1, v do
				table.insert(rw, k)
			end
		end
		local rand = math.random(1, #rw)
		return rw[rand]			
	end
	
	init()
	return self
end

