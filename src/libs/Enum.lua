local function splitStr(s)
	local strs = {}
	
	local iter = s:gmatch("[^%s]+")				-- iter that splits on spaces
	for str in iter do
		table.insert(strs, str)					-- insert all strs into an array
	end
	
	local keys, t = {}, {}
	for _, v in ipairs(strs) do
		if not keys[v] then						-- check strs for duplicate keys
			t[#t+1] = v
			keys[v] = true
		else error("Enum declared with duplicate identifiers!\nEnum:\t{" .. s .. "}") end
	end

	return t
end

------------------------------------------------------------------------------
local function Enum(s, light)
	local t, enums, strs = {}, {}, {}
	
	strs = splitStr(s)					-- split the constructor string in an array

	local i = 1
	for _, str in ipairs(strs) do
		if not light then 
			enums[str .. "__string"] = str	-- set enumName__string to enumName
		end
		enums[str] = i						-- set the value of enumName to an ordinal
		i = i + 1
	end
	
	setmetatable(t, t)
	function t.__index(_, k) 
		local v = enums[k]
--		assert(v, "Attempt to access non-existent enum-constant!\nEnum:\t{" .. s .. "}")
		return v 
	end
	function t.__newindex() 
		error("Attempt to alter contents of an enum!\nEnum:\t{" .. s .. "}") 
	end 
	
	return t
end

return Enum

--[=[
---declaration:
local Stats = Enum [[NAME DESC SPR SPEED HEALTH DAMAGE
		WIDTH HEIGHT SOLID OPAQUE MAX_STACK]]

---usage:
getStat(Stats.NAME)					-- getStat(0)
getStat(Stats.NAME__string)			-- getStat("NAME")

Stats.NAME = 3				-- does NOT set, and throws an illegal modification error
Stats.FOO = 3				-- does NOT set, and throws an illegal modification error
							-- (even though member is also non-existent)

getStat(Stats.FOO)			-- throws a member non-existent error.
--]=]
