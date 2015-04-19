local Diner = class("Diner", Scene)

local Waiter   = require "entities/Waiter"
local Level    = require "entities/Level"
local CameraManager = require "CameraManager"
local Customer = require "entities/Customer"
local SpeechBubble = require "SpeechBubble" 

local METER = SquareSize

function Diner:initialize()
   Scene.initialize(self)
   
   love.physics.setMeter(METER)
   self.world = love.physics.newWorld(0,0, true)
   self.level = Level:new(0,0,"level0.lvl",self)
   self.cammgr = CameraManager:new(self)

   self.waiter = self:addEntity(Waiter:new(400, 100, self))

   self.test = 200
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
		self.test:navigate(8, 3)
	elseif key == "t" then
		local t = self:addEntity(SpeechBubble:new(self.test, 200, self))
		self.test = self.test + 40
		local f = love.math.random(1,3)
		t:requestFood(f)
		t:spawn()
	end
	Scene.keypressed(self, key, isrepeat)
end

return Diner
