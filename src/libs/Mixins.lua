local Mixins = {
  _VERSION = "Mixins v2.1.0",
  
  _MADE_FOR_VERSIONS = [[
  	- middleclass  v4.1.1 
  	- MixinEdit    v1.2.0 
  	- NamingRevamp v1.0.0
  ]],
  
  _DESCRIPTION = "A handful of utilities for creating mixins.",
  
  _URL = [[
  	NamingRevamp: https://github.com/ActivexDiamond/MixinUtils
  ]],
  
  _LICENSE = [[
    tl;dr: You can do whatever you want with this. Edit it, use it as is,
    make money, make content; knock yourself out. 
  ]],
  
  _AUTHOR = [[
  	Dulfiqar 'Active Diamond' Al-Safi
  ]],
}
local print = function() end

local function joinInclusions(f1, f2)
	print("Joining inclusions.")
	return function(self, class)
		f1(self, class)
		f2(self, class)
	end
end
local function callAll(self, functions)
	for _, v in ipairs(functions) do v(self) end
end

--- @param #table mixin the to add the methods to.
--  @param #function ... Any number of functions to call after the class is initialized. Each getting passed the newly created instance as their "self" paramter.
--function Mixins.onPostInit(mixin, ...)
--	local functions = {...}
--	local included = function(self, class)
--		local new = class.__new
--		function class:__new(...)
--			print("onPostInit:" .. mixin.__name__)
----			local instance = new(self, ...)
--			local instance = class:__allocate()
--			instance:init(...)
--			callAll(instance, functions)
--			return instance
--		end
--	end	
--	print("mixin.__included", mixin.__included)
--	mixin.__included = mixin.__included and
--		joinInclusions(mixin.__included, included) or included
--end

function Mixins:__call(str, isuper)
--	local t = {__name__ = str}
-- 	t.isuper = isuper
-- 	t.__index = function(t, k) return t.isuper and t.isuper[k] end
--	return setmetatable(t, t)
	return setmetatable({__name__ = str, isuper = isuper},
			isuper and {__index = function(t, k) return t.isuper[k] end} or {}
	)
end

setmetatable(Mixins, Mixins)

return Mixins