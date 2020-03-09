local tables = {}

------------------------------ addByIndex ------------------------------
---insert all contents of t2+..., into t1. Using the same keys/indices that t2 used,
--override if necessary.
function tables.fAddByIndex(...)
	local args = {...}
	local t = args[1]
	for i = 1, #args do
		for k, v in pairs(args[i]) do
			t[k] = v
		end
	end
end

function tables.addByIndex(...)
	local args = {...}
	local t = args[1]
	for i = 1, #args do
		for k, v in pairs(args[i]) do
			if not t[k] then t[k] = v end
		end
	end
end

------------------------------ Non-Mutating AddByIndex ------------------------------
---return new table containing a combinations of t1 and t2 ...
--override if necessary.
--similar to table.fAddByIndex, except it returns a new table, not altering t1/t2.
--non-mutating, forced, addByIndex.
function tables.nfAddByIndex(...)
	local args = {...}
	local t = {}
	
	for i = 1, #args do
		for k, v in pairs(args[i]) do
			t[k] = v
		end
	end
	return t
end

------------------------------ Misc. Utils ------------------------------
function tables.clone(t2)
	local t = {}
	for k, v in pairs(t2) do
		t[k] = v
	end
	return t
end

function tables.isEmpty(t)
	local b = true
	for _, _ in pairs(t) do
		b = false
	end
	return b
end

function tables.isEmptyDeep(t)
	local b = true
	for _, v in pairs(t) do
		if type(v) == 'table' then
			b = tables.isEmptyDeep(v)
		else b = false end
	end
	return b
end

------------------------------ Debug-Utils ------------------------------
---Prints the all k, v pairs in the given table(s).
function tables.print(...)
	local args = {...}
	local n, ind
	
	local function indent(n)
		n = n or 0
		n = n * 4
		for i = 1, n do
			io.write(" ")
		end		
	end
			
	if type(args[1]) == 'string' then
		if type(args[2]) == 'number' then
			ind = args[2]
			n = 3
		else n = 2 ind = 0 end
		
		indent(ind)
		io.write(" -----" .. args[1] .. "-----")
	else
		n = 1
		ind = 0
		io.write(" --------------")
	end
	
	local t = args[n]
	if type(t) ~= 'table' then 
		io.write('\n')
		indent(ind)
		print(" table is nil.")
	elseif tables.isEmpty(t) then
	 	io.write('\n')
		indent(ind)
		print(" table is empty.")
	end
	
	for i = n, #args do
	if not tables.isEmpty(args[i]) then
			io.write("\n")
			for k, v in pairs(args[i]) do
				if type(v) == 'table' then
					tables.print(tostring(k), ind + 4, v)
				else
					indent(ind)
					local index = i - (n-1)
					if ind == 0 then io.write(" t" .. index .. ":    ")
					else io.write(" t" .. index .. "-" .. ind/4 .. ":    ") end 
					io.write(k)
					io.write(" = ")
					print(v)
				end
			end
		end
	end
	indent(ind)
	io.write("<------------->\n")
	if ind == 0 then io.write('\n') end
end

return tables