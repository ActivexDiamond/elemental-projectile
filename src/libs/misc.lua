
local misc = {}

------------------------------ Color Mapping ------------------------------
local function mapColor(min, max, nmin, nmax, ...)
	local c = type(...) == "table" and ... or {...}
	local rc = {}
	for i = 1, 4 do
		local v = c[i] or max
		rc[i] = misc.map(v, min, max, nmin, nmax)
	end
	return rc
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 255
-- @return #color It's input mapped from [0, 255] to [0, 1].
function misc.toLoveColor(...)
	return mapColor(0, 255, 0, 1, ...)
end

--- @param #color ... Either a table {r, g, b, a}, or direct r, g, b, a values.
-- 						Missing values default to 1
-- @return #color It's input mapped to from [0, 1] to [0, 255].
function misc.to8bitColor(...)
	return mapColor(0, 1, 0, 255, ...)
end

------------------------------ Misc Math ------------------------------
function misc.map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

function misc.constrain(x, min, max)
	return math.max(math.min(x, max), min)
end

function misc.snap(grid, x, y)
	return (math.floor(x / grid) * grid), y and (math.floor(y / grid) * grid) or nil
end

------------------------------ Tables ------------------------------
function misc.hasArray(t)
	for k, v in ipairs(t) do
		return true
	end
	return false
end

function misc.hasHashtable(t)
	for k, v in pairs(t) do
		if type(k) ~= 'number' then return true end
	end
	return false
end

function misc.isArray(t)
	return misc.hasArray(t) and not misc.hasHashtable(t)
end

function misc.isHashtable(t)
	return misc.hasHashtable(t) and not misc.hasArray(t)
end

------------------------------ Compares ------------------------------
function misc.equals(obj, ...)
	for k, v in ipairs{...} do
		if obj ~= v then
			return false
		end
	end
	return true
end

function misc.notEquals(obj, ...)
	for k, v in ipairs{...} do
		if obj == v then
			return false
		end
	end
	return true
end

function misc.equalsAny(obj, ...)
	for k, v in ipairs{...} do
		if obj == v then
			return true
		end
	end
	return false
end
------------------------------ DataStruct Targeters ------------------------------
function misc.targetQueue(queue)
	local qt = {}
	qt.target = queue
	function qt:cur() return queue[1] end
	--TODO: Make this method take more reasonable args.
	function qt:curt(k) return k and type(qt.cur()[k]) or type(qt.cur()) end 
	function qt.add(obj) return table.insert(queue, obj) end
	function qt.rem() return table.remove(queue, 1) end
	return qt
end

------------------------------ Conversion Methods ------------------------------
function misc.toBin(n, bits, seg, space, sep) 
	local t, s, nb = {}, seg
	local space = space or ' ' 
	if n == 0 then nb = 1
	else nb = math.floor(math.log(n) / math.log(2)) + 1 end		--neededBits = roundUp(log2(n))

	for b = nb, 1, -1 do
		local rest = math.fmod(n, 2)
		table.insert(t, 1, rest)
		if seg then
			s = s - 1
			if s == 0 then table.insert(t, 1, space) ; s = seg end
		end
		n = (n - rest) / 2
	end
	
	if bits and bits > nb then 
		for i = 1, bits - nb do 
			table.insert(t, 1, '0') 
			if seg then
				s = s - 1
				if s == 0 then table.insert(t, 1, space) ; s = seg end
			end
		end
	end
		
	return table.concat(t, sep)
end

------------------------------ Lua-Related ------------------------------
function misc.selectArg(t, ...)			--selectArg(type, args)
	local i, p = 1, tonumber(t:sub(1, 1))
	if type(p) == 'number' then
		i, t = p, t:sub(2, -1)
	end
	
	if t == 's' then t = 'string'
	elseif t == 'n' then t = 'number'
	elseif t == 'f' then t = 'function'
	elseif t == 't' then t = 'table'
	elseif t == 'ni' then t = 'nil'
	elseif t == 'th' then t = 'thread'
	elseif t == 'u' then t = 'userdata' end
	for k, v in ipairs({...}) do
		if type(v) == t then i = i - 1; if i == 0 then return v end end
	end
end

do
	local UNDEF = {}
	---Create Helpers
	local function createHelpers(queue)
		local cur = function() return type(queue[1]) end 
		local pop = function(t) return table.remove(t or queue, 1) end
		local add = function(t, obj) return table.insert(t or queue, obj) end
		return cur, pop, add
	end
	
	local function cleanNils(t)
		local n = 0
		for k, v in pairs(t) do n = math.max(k, n) end
		if n == 0 then return t end
		for i = 1, n do
			if type(t[i]) == 'nil' then t[i] = UNDEF end 
		end
		return t
	end

	---Get Flag
	local function getFlag(fParams)
		local flag;
		local cur, pop, add = createHelpers(fParams)
		if cur() == 'string' then
			local arg1 = fParams[1]
			flag = arg1:sub(1, 1) == '-' and arg1 or nil
		end
		if flag then pop() end
		return flag
	end
	
	---Cleaners
	local function cleanupFuncArgs(fCleanup, fArgs)
		if fCleanup == -1 or not fArgs then return fArgs end
		local cur, pop, add = createHelpers(fCleanup)
		local cleanFuncArgs = {}
		local cleaner = pop()
		if #fCleanup == 0 then
			for k, v in ipairs(fArgs) do cleanFuncArgs[k] = cleaner(v) end
		else 
			cleanFuncArgs = fArgs
			for _, i in ipairs(fCleanup) do
				cleanFuncArgs[i] = cleaner(fArgs[i])
			end		
		end
		return cleanFuncArgs
	end
	
	local function cleanupAllArgs(...)
		local args = {...} 
 		local cur, pop, add = createHelpers(args)
		local commonArgs, cleanCommonArgs
		local funcs, fParams, fCleanups = {}, {}, {} 
		
		commonArgs = cleanNils(pop())
		if cur() == 'table' then						
			local cct = pop()				--common-cleaner-table
			local cleaner = pop(cct)		--common-cleaner
			if #cct == 0 then					
				for k, v in ipairs(commonArgs) do
					cleanCommonArgs[k] = cleaner(v)
				end
			else 
				cleanCommonArgs = commonArgs
				for _, i in ipairs(cct) do
					cleanCommonArgs[i] = cleaner(commonArgs[i])
				end
			end
		else cleanCommonArgs = commonArgs end 
		
		for i = 1, #args / 2 do
			add(funcs, pop())
			add(fParams, pop())
			if cur() == 'table' then add(fCleanups, pop())
			else add(fCleanups, -1) end
		end
		return cleanCommonArgs, funcs, fParams, fCleanups
	end
	
	---Check Eligibility
	local function checkLuaVal(p, arg)
		local t = type
		if p == 's' then p = 'string'
		elseif p == 'n' then p = 'number'
		elseif p == 'f' then p = 'function'
		elseif p == 't' then p = 'table'
		elseif p == 'ni' then p = 'nil'
		elseif p == 'th' then p = 'thread'
		elseif p == 'u' then p = 'userdata' end
		
		if p == t(arg) then return true
		else return false end	
	end
	
	local function checkObject(p, arg)
		p = p.class or p
		return type(arg) == 'table' and arg.instanceof and arg:instanceof(p)
	end
	
	local function checkParam(p, arg)
		if p == UNDEF then return false
		elseif type(p) == 'string' then return checkLuaVal(p, arg)
		elseif type(p) == 'table' then return checkObject(p, arg)  end
	end
	
	local function checkNoFlag(cleanArgs, func, fParams)
		local found, lastFoundIndex  = {}, 0
		local missing = #fParams
		for i, param in ipairs(fParams) do			
			for k, arg in ipairs(cleanArgs) do
				if missing > 0 and k >= i and checkParam(param, arg) then
					table.insert(found, arg)
					missing = missing - 1
					lastFoundIndex = k
					break
				end
			end
--		print('?')
		end
		
		if lastFoundIndex > 0 then
			for i = lastFoundIndex + 1, #cleanArgs do
				table.insert(found, cleanArgs[i])
			end
		end
		if missing == 0 then return func, found
		else return nil end
	end
	
	local function checkMinimal(cleanArgs, func, fParams)
--		TODO: Implement -m flag.
		error "TODO: Implement -m flag in misc.overload."
	end
	
	local function checkStrict(cleanArgs, func, fParams)
--		TODO: Implement -s flag.	
		error "TODO: Implement -s flag in misc.overload."
	end
	
	---Overload	
	function misc.ovld(...)
		local cleanArgs, funcs, fParams, fCleanups = cleanupAllArgs(...)
		local cur, pop, add = createHelpers(cleanArgs)
		
		if DEBUG.OVERLOAD then
			utils.t.print("cleanArgs", cleanArgs)
			utils.t.print("funcs", funcs)
			utils.t.print("fParams", fParams)
			utils.t.print("fCleanups", fCleanups)
			utils.t.print("{...}", {...})
		end
		
		for k, func in ipairs(funcs) do
			local flag = getFlag(fParams[k])
			local check, fArgs, cleanFuncArgs;
			if not flag then check = checkNoFlag 
			elseif flag == '-m' then check = checkMinimal
			elseif flag == '-s' then check = checkStrict end
			check, fArgs = check(cleanArgs, func, fParams[k])
			if check then
				local cleanFuncArgs = cleanupFuncArgs(fCleanups[k], fArgs)
				return check(unpack(cleanFuncArgs))
			end
		end
	end
end

------------------------------ Lib Wrappers ------------------------------
misc.b2 = {}
function misc.b2.queryRect(b2world, x, y, w, h)
	local rtVal = {}
	b2world:queryBoundingBox(x, y, x+w, y+h, function(fixt)
		table.insert(rtVal, fixt)
		return true
	end)
	return rtVal
end

return misc















