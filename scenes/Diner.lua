local Diner = class("Diner", Scene)

local Waiter   = require "entities/Waiter"
local Level    = require "entities/Level"
local CameraManager = require "CameraManager"
local Customer = require "entities/Customer"

local METER = SquareSize

function Diner:initialize()
   Scene.initialize(self)
   
   love.physics.setMeter(METER)
   self.world = love.physics.newWorld(0,0, true)
   self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)


   self.level = Level:new(0,0,"level0.lvl",self)
   self.cammgr = CameraManager:new(self)

   self.waiter = self:addEntity(Waiter:new(400, 100, self))
end

function Diner:update(dt)
	Timer.update(dt)

   --self.cammgr:update(self.level.width/2,self.level.height/2)
   self.cammgr:update(self.waiter.x,self.waiter.y)
	self.world:update(dt)
	Scene.update(self, dt)
end

function Diner:draw()
   self.cammgr:attach()
   self.level:draw()
	Scene.draw(self)
   self.cammgr:detach()
end

function Diner:keypressed(key, isrepeat)
	if key == "s" then
		self.test = self:addEntity(Customer:new(0, 0, self))
		self.test:navigate(2, 10, 8, 3)
	end
	Scene.keypressed(self, key, isrepeat)
end

function Diner:beginContact(a,b,coll)
end

function Diner:endContact(a,b,coll)
end

function Diner:preSolve(a,b,coll)
end

function Diner:postSolve(...)
end


return Diner
