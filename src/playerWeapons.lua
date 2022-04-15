local t = {}

t.WaterBall = {
	name = "Water Ball",
    type = 'water',

    cost = 5,
    cooldown = 0.1,

    color = {0, 0, 1},

    r = 5,
    speed = 2000,
    dmg = 5,
}

t.WaterBomb = {
	name = "Water Bomb",
    type = 'water',

    cost = 25,
    cooldown = 1,

    color = {0, 0, 1},

    r = 15,
    speed = 200,
    dmg = 500,
}


return {
    default = {
        primary = x,
        secondary = x,
    },
    water = {
        primary = t.WaterBall,
        secondary = t.WaterBomb,
    },
    lava = {
        primary = x,
        secondary = x,
    },
}
