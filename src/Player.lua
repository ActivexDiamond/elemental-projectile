local WaterBall = require "WaterBall"
local Stat = require "Stat"

return function()
	local self = {}
	self.TYPE =  g.type("Mob", "Player")
	self.ID = "player"
	self.x, self.y = 0, 0
	self.w, self.h = 32, 32
	self.color = {.5, .5, 1, 1}
	
	self.speed = 2
	self.sprint = 6
	self.jump = 75
	
	self.stamina = Stat{
		coolMax = 30, 
		coolMin = 5,
		regen = 5
	}

	self.fluid = Stat{
		cur = 0
		
	}	
	
	self.sprintDrain = 2
	self.jumpDrain = 50
	
	
--	self.water = 0
--	self.waterMax = 100
--	self.waterRegen = 20
	self.waterToStaminaPer = 10
	self.waterToStaminaGain = 20
	
	self.waterBallDrain = 5
	
	function self:tick(dt)
		local k = love.keyboard.isDown 
		
		---sprint
		if k('lshift') and self.stamina:rem(self.sprintDrain) then 
			self.vel = self.sprint
		else self.vel = self.speed end
		---move
		if k('w') then self.y = self.y - self.vel end
		if k('s') then self.y = self.y + self.vel end
		if k('a') then self.x = self.x - self.vel end
		if k('d') then self.x = self.x + self.vel end
		---bind pos
		self.x = math.max(math.min(self.x, sw-self.w), 0)
		self.y = math.max(math.min(self.y, sh-self.h), 0)
			
		self.stamina:tick(dt)
		self.fluid:tick(dt)
	end
	
	function self:draw(g2d)
		---draw self
		g2d.setColor(self.color)
		g2d.rectangle('fill', self.x, self.y, self.w, self.h)
		
		---draw stats
		self.stamina:draw(g2d, 1, "Stamina", {0, 1, 0, 1})
		self.fluid:draw(g2d, 2, self.fluidCur, {0, 0, 1, 1})
	end
	
	function self:onCollision(other)
		if other.TYPE:is("Pickup") then
			if other.ID == "pond" then
				if self.fluid:add(other.amount) then g.world:remove(other) end
			end
		elseif other.TYPE:is("") then
		
		end
	end
	
	function self:waterBall(x, y)
		if self.water > self.waterBallDrain then
			self.water = self.water - self.waterBallDrain
			local proj = WaterBall(self.x + self.w/2, self.y + self.h/2)
			proj:setDir(x, y)
			world:add(proj)
			return true
		end
	return false
	end
	
	function self:onKeyPressed(k)
		local isDown = love.keyboard.isDown
		---jump
		if k == 'space' and self.stamina:rem(self.jumpDrain) then
			if isDown('w') then self.y = self.y - self.jump end
			if isDown('s') then self.y = self.y + self.jump end
			if isDown('a') then self.x = self.x - self.jump end
			if isDown('d') then self.x = self.x + self.jump end
		end
		---bind pos
		self.x = math.max(math.min(self.x, sw-self.w), 0)
		self.y = math.max(math.min(self.y, sh-self.h), 0)

		---action
		if k == 'up' then self:waterBall(0, -1) end
		if k == 'down' then self:waterBall(0, 1) end
		if k == 'left' then self:waterBall(-1, 0) end
		if k == 'right' then self:waterBall(1, 0) end
		
		if k == 'q' then 
			if not self.stamina:full() and self.fluid:rem(self.waterToStaminaPer) then
				self.stamina:add(self.waterToStaminaGain)
			end
		end	
	end
	
	return self
end