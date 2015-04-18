local Diner = class("Diner", Scene)

local Waiter   = require "entities/Waiter"
local Level    = require "entities/Level"
local CameraManager = require "CameraManager"

local METER = SquareSize

function Diner:initialize()
   Scene.initialize(self)
   
   love.physics.setMeter(METER)
   self.world = love.physics.newWorld(0,0, true)
   self.level = Level:new(0,0,"level0.lvl",self)
   self.cammgr = CameraManager:new(self)

   self:addEntity(Waiter:new(400, 100, self))
end

function Diner:update(dt)
	Timer.update(dt)
   self.cammgr:update(self.level.width/2,self.level.height/2)
	self.world:update(dt)
	Scene.update(self, dt)
end

function Diner:draw()
   self.cammgr:attach()
   self.level:draw()
	Scene.draw(self)
   self.cammgr:detach()
end

return Diner
