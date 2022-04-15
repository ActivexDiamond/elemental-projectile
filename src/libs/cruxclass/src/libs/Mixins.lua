local Mixins = {
  _VERSION = "Mixins v1.0.0",
  
  _MADE_FOR_VERSIONS = [[
  	- middleclass  v4.1.1 
  	- MixinEdit    v1.0.0 
  	- NamingRevamp v1.0.0
  ]],
  
  _DESCRIPTION = "A handful of utilities for creating mixins.",
  
  _URL = [[
  	Mixins: https://github.com/ActivexDiamond/cruxclass (TODO: seperate into it's own repo.)
  ]],
  
  _LICENSE = [[
    MIT LICENSE
    Copyright (c) 2011 Enrique García Cota
    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]],
}

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
function Mixins.onPostInit(mixin, ...)
	print("onPostInit")
	local functions = {...}
	local included = function(self, class)
		local new = class.__new
		function class:__new(...)
			local instance = new(self, ...)
			callAll(instance, functions)
			return instance
		end
	end	
	print("mixin.__included", mixin.__included)
	mixin.__included = mixin.__included and
		joinInclusions(mixin.__included, included) or included
end

return Mixins