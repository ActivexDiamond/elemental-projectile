local class = require "libs.cruxclass"
local Obj = class("Obj")

function Obj:init(x, y)
	self.x = x
	self.y = y
end

function Obj:echo() print(self.x, self.y) end

local obj = Obj(3, 3)
obj:echo()
obj.x = 2
obj:echo()

local case;

for k, v in pairs(Obj.__mixins__) do print(k, v) end

local Mixin = {}
function Mixin:mixEcho() print(self.class.name) end
local Obj = Obj:include(Mixin)
local Obj = Obj:include(Mixin)

for k, v in pairs(Obj.__mixins__) do print(k, v) end

local obj2 = Obj(4, 4)
obj2:mixEcho()

case = obj2:instanceof(Obj)
print(case)
case = obj2.class:subclassof(Obj)
print(case)

print(obj.__mixins__)
print(obj2.__mixins__)
print(Obj.__mixins__)


case = obj:instanceof(Mixin)
print(case)
case = obj2:instanceof(Mixin)
print(case)
case = Obj:instanceof(Mixin)
print(case)

print "-----"
case = obj.class:subclassof(Mixin)
print(case)
case = obj2.class:subclassof(Mixin)
print(case)
case = Obj:subclassof(Mixin)
print(case)

  instanceof = function(sel, aClass)
    return type(aClass) == 'table'
       and type(sel) == 'table'
       and (sel.class == aClass	
            or type(sel.class) == 'table'
            and (_tableContains(sel.class.__mixins__, aClass) ----------
	            or type(sel.class.subclassof) == 'function'
	            and sel.class:subclassof(aClass)))
  end
  
local Tickable = {tick = function() end }
local Furnace = class("Furnace"):include(Tickable)
local Pulv = class("Pulv", Furnace)

print "=========="
case = Furnace:subclassof(Furnace)
print(case)
case = Furnace:subclassof(Tickable)
print(case)

print "----------"

case = Pulv:subclassof(Furnace)
print(case)
case = Pulv:subclassof(Tickable)
print(case)



--[[

local ITickable = Mixin("ITickable")

local ITickable = {}

function ITickable:tick()

	--do stuff

end


local Skeleton = class("Skeleton", Mob):include(ITickable)


local skeleton = Skeleton()

skeleton:tick()		--ticks


function tickAll(entities)

	for _, v in ipairs(entities) do

		if v.super:

	end

end


obj:instanceof(class/mixin) -- takes a class, or a mixin

	searches entire class heirarchy,

	and thus searching entire list of __mixins__ for every

	class in the heirarchy	

	returns false if passed an instance

	

Obj:subclassof(class/mixin) -- takes a class, or a mixin

	searches entire class heirarchy,

	and thus searching entire list of __mixins__ for every

	class in the heirarchy	

	returns false if passed an instance
--]]