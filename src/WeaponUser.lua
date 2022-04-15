local Projectile = require "Projectile"

return function(parent, weapons, mags, activeWeaponSet, activeWeaponSlot)
	local self = {}
	self.TYPE =  g.type("Technical", "User")
	self.ID = "weapon_user"

    --state
    self.parent = parent
	self.weapons = weapons
	self.mags = mags
	self.activeWeaponSet = activeWeaponSet or 'default'
	self.activeWeaponSlot = activeWeaponSlot or 'primary'

	self.weaponCooldown = {
		primary = 0,
		secondary = 0,
	}

	function self:tick(dt)
		--update timers
		if self.weaponCooldown[self.activeWeaponSlot] > 0 then
            self.weaponCooldown[self.activeWeaponSlot] = math.max(self.weaponCooldown[self.activeWeaponSlot] - dt, 0)
        end
	end

	function self:draw(g2d, line)
		---draw stats
		g2d.push('all')
			g2d.setColor(0.5, 0.5, 0.5, 1)
	        local str = string.format("Weapon Set: %s", self.activeWeaponSet)
	        g2d.print(str, 20, line * 20)
	        line = line + 1
	        str = string.format("Weapon Slot: %s", self.activeWeaponSlot)
	        g2d.print(str, 20, line * 20)
	        line = line + 1
	        str = string.format("Weapon Cooldown: %.2f", self.weaponCooldown[self.activeWeaponSlot])
			g2d.print(str, 20, line * 20)
			line = line + 1
			g2d.setColor(1, 1, 1, 1)
	        str = string.format("Weapon: %s", self.weapons[self.activeWeaponSet][self.activeWeaponSlot].name)
			g2d.print(str, 20, line * 20)
		g2d.pop()
	end

	function self:shoot(xDir, yDir, x, y)
		local wpn = self.weapons[self.activeWeaponSet][self.activeWeaponSlot]
		if self.weaponCooldown[self.activeWeaponSlot] <= 0 and self.mags[wpn.type]:rem(wpn.cost) then
			self.weaponCooldown[self.activeWeaponSlot] = wpn.cooldown
			local user = self.parent
			x = x or user.x + user.w/2
			y = y or user.y + user.h/2
			return Projectile(wpn, x, y, xDir, yDir)
		end
		return false
	end

    function self:toggleActiveWeaponSlot()
        self.activeWeaponSlot = self.activeWeaponSlot == 'primary'
                and 'secondary' or 'primary'
    end

	return self
end
