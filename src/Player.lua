local WeaponUser = require "WeaponUser"
local playerWeapons = require "playerWeapons"
local Projectile = require "Projectile"
local Stat = require "Stat"

local function tableSize(t)
	local i = 0
	for k, v in pairs(t) do
		i = i + 1
	end
	return i
end

KEYBINDS = {
	'water',
	'lava',
}

return function()
	local self = {}
	self.TYPE =  g.type("Mob", "Player")
	self.ID = "player"
	self.x, self.y = 0, 0

	--graphics stats
	self.w, self.h = 32, 32
	self.color = {.5, .5, 1, 1}

	--movement stats
	self.speed = 200
	self.sprint = 400
	self.jump = 75

	self.sprintDrain = 0			-- DISABLED
	self.jumpDrain = 50

	self.stamina = Stat{
		coolMax = 30,
		coolMin = 5,
		regen = 5
	}

	--state
	self.fluids = {
		water = Stat{cur = 0},
		lava = Stat{cur = 0},
	}
	--self:setActiveFluid('water') 			--Lack of proper init sequence.
	self.activeFluidId = KEYBINDS[1]
	self.activeFluid = self.fluids[self.activeFluidId]

	self.weaponUser = WeaponUser(self, playerWeapons, self.fluids, 'water', 'primary')

	--temp
	self.waterToStaminaPer = 20
	self.waterToStaminaGain = 100


	function self:tick(dt)
		local k = love.keyboard.isDown
		---sprint DISABLED, constantly on. Decided that it doesn't make much sense in this game.
		if true or (k('lshift') and self.stamina:rem(self.sprintDrain)) then
			self.vel = self.sprint * dt
		else self.vel = self.speed * dt end
		---move
		--FIXME: Diagonals are faster.
		if k('w') then self.y = self.y - self.vel end
		if k('s') then self.y = self.y + self.vel end
		if k('a') then self.x = self.x - self.vel end
		if k('d') then self.x = self.x + self.vel end
		---bind pos
		self.x = math.max(math.min(self.x, sw-self.w), 0)
		self.y = math.max(math.min(self.y, sh-self.h), 0)

		---update stats
		self.stamina:tick(dt)
		for k, v in pairs(self.fluids) do
			v:tick(dt)
		end
		---update timers
		self.weaponUser:tick(dt)
	end

	function self:draw(g2d)
		---draw self
		g2d.setColor(self.color)
		g2d.rectangle('fill', self.x, self.y, self.w, self.h)

		---draw stats
		self.stamina:draw(g2d, 1, "Stamina", {0.8, 0.8, 0.8})
		self.fluids.water:draw(g2d, 2, "Water", {0, 0, 1})
		self.fluids.lava:draw(g2d, 3, "Lava", {1, 0, 0})

		self.weaponUser:draw(g2d, 4)
	end

	function self:onCollision(other)
		---Pickups
		if other.TYPE:is("Pickup") then
			--Ponds
			if other.ID == "pond" then
				if self.activeFluidId ~= other.fluidId then return end
				
				if self.activeFluid:add(other.amount) then 
					g.world:remove(other)
				end
			end
		---Other
		elseif other.TYPE:is("") then

		end
	end

	function self:onKeyPressed(k)
		local isDown = love.keyboard.isDown
		---jump
		--FIXME: Diagonals are faster.
		--FIXME: Still drains stamina if pressed while not moving in any direction.
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
		if k == 'lshift' then
			self.weaponUser:toggleActiveWeaponSlot()
		end

		if k == 'up' then self.weaponUser:shoot(0, -1) end
		if k == 'down' then self.weaponUser:shoot(0, 1) end
		if k == 'left' then self.weaponUser:shoot(-1, 0) end
		if k == 'right' then self.weaponUser:shoot(1, 0) end

		if k == 'q' then
			if not self.stamina:full() and self.activeFluid:rem(self.waterToStaminaPer) then
				self.stamina:add(self.waterToStaminaGain)
			end
		end

		local numeric = tonumber(k)
		if numeric and numeric <= tableSize(self.fluids) then
			self:setActiveFluid(KEYBINDS[numeric])
		end
	end

	function self:setActiveFluid(id)
		self.activeFluidId = id
		self.activeFluid = self.fluids[id]
		print(id, self.fluids[id])
	end

	return self
end
