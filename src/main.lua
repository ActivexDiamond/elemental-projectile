local lovebird = require "libs.lovebird"
lovebird:update()

local World = require "World"
local Player = require "Player"
local PondGen = require "PondGen"
local ObjType = require "ObjType"

sw, sh = love.window.getMode()
g = {}
g.type = ObjType

g.world = World()

function love.load()
	g.world:add(PondGen())
	
	local player = Player()
	player.x, player.y = (sw-player.w) / 2, (sh-player.h) / 2
	g.world:add(player)	
end

function love.update(dt)
	lovebird:update(dt)
	g.world:tick(dt)
end

function love.draw()
	local g2d = love.graphics
	g.world:draw(g2d)
end

function love.keypressed(k)
	g.world:onKeyPressed(k)
end

function love.keyreleased(k)
	g.world:onKeyReleased(k)
end
