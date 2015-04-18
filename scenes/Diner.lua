local Diner = class("Diner", Scene)

local Waiter   = require "entities/Waiter"
local Level    = require "entities/Level"
local METER = SquareSize

function Diner:initialize()
   Scene.initialize(self)
   love.physics.setMeter(METER)
   self.world = love.physics.newWorld(0,0, true)
   self:addEntity(Level:new(0,0,"level0.lvl",self))
   self:addEntity(Waiter:new(400, 100, self))
end

function Diner:update(dt)
	self.world:update(dt)
	Scene.update(self, dt)
end

function Diner:draw()
	Scene.draw(self)
end

return Diner
