function map(x, min, max, nmin, nmax)
 return (x - min) * (nmax - nmin) / (max - min) + nmin
end

function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end
function intersectsCircle(x, y, cx, cy, cr)
    local d = distance(x, y, cx, cy)
    return d - cr < 0
end

function updateRng()
    curLife = math.random(life[1], life[2])
    curSpawnRate = math.random(spawnRate[1], spawnRate[2])
end

function Circle(life)
    local self = {}

    self.x = math.random(0, sw)
    self.y = math.random(0, sh)

    self.baseRadius = baseRadius
    self.maxRadius = baseRadius * 4
    self.life = life
    self.maxLife = life

    function self:update(dt)
        self.life = self.life - dt
        self.r = map(1-self.life/self.maxLife, 0, self.maxLife, self.baseRadius, self.maxRadius)

        if self.life <= 0 then
            return true
        end
    end

    function self:draw(g)
        local red = self.life / self.maxLife
        g.setColor(1-red, 0.2, 0.2)
        g.circle('fill', self.x, self.y, self.r)
        g.setColor(1, 1, 1)
        g.print(self.maxLife, self.x-4, self.y-8)
    end
    return self
end

-- config
life = {2, 5}
spawnRate = {0.2, 1}
health = 6
maxCircles = 10
baseRadius = 10
-- globals
sw, sh = love.window.getMode()

-- state
circles = {}
score = 0
lastTime = love.timer.getTime()

curSpawnRate = 0
curLife = 0
updateRng()

function love.update(dt)
    if love.timer.getTime() - lastTime > curSpawnRate and #circles < maxCircles then
        table.insert(circles, Circle(curLife, baseRadius))
        updateRng()
        lastTime = love.timer.getTime()
    end

    for i = #circles, 1, -1 do
        local obj = circles[i]
        if obj:update(dt) then
            table.remove(circles, i)
            health = health - 1
            if health == 0 then
                gameOver = true
            end
        end
    end
end

function love.draw()
    local g = love.graphics
    for k, v in ipairs(circles) do
        v:draw(g)
    end
    if gameOver then
        g.setColor(1, 1, 1)
        g.print("Game Over!", sw/2, sh/2)
    end

    g.setColor(1, 1, 1)
    g.print(score, 20, 20)
    g.print(health, 20, 40)
end

function love.mousepressed(x, y)
    for i = #circles, 1, -1 do
        local obj = circles[i]
        if intersectsCircle(x, y, obj.x, obj.y, obj.r) then
            table.remove(circles, i)
            score = score + 1
        end
    end
end
