local class = require 'middleclass'

  DrinksCoffee = {static = {}}

  -- This is another valid way of declaring functions on a mixin.
  -- Note that we are using the : operator, so there's an implicit self parameter
  function DrinksCoffee:drink(drinkTime)
    if(drinkTime~=self.class.coffeeTime) then
      print(self.name .. ': It is not the time to drink coffee!')
    else
      print(self.name .. ': Mmm I love coffee at ' .. drinkTime)
    end
  end
  

  -- the included method is invoked every time DrinksCoffee is included on a class
  -- notice that paramters can be passed around
  function DrinksCoffee:included(klass)
    print(klass.name .. ' drinks coffee at ' .. klass.coffeeTime)
    klass.static.x = 0
    klass.static.x = klass.static.x + 1
    print('x', klass.x)
  end

  EnglishMan = class('EnglishMan')
  EnglishMan.static.coffeeTime = 5
  EnglishMan:include(DrinksCoffee)
  function EnglishMan:init(name) self.name = name end
  EnglishMan.y = 1
  EnglishMan.static.z = 1

  Spaniard = class('Spaniard')
  Spaniard.static.coffeeTime = 6
  Spaniard:include(DrinksCoffee)
  function Spaniard:init(name) self.name = name end

  tom = EnglishMan:new('tom')
  juan = Spaniard:new('juan')
	
--  EnglishMan:drink(5)	
  tom:drink(5)
  juan:drink(5)
  juan:drink(6)

  print(tom.x)
  print(EnglishMan.x)
  print("---")
  print('y', tom.y)
  print('sy', EnglishMan.y)
  print('z', tom.z)
  print('sz', EnglishMan.z)

