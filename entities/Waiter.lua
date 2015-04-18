local Waiter = class("Waiter", Entity)
local lg = love.graphics
local lp = love.physics

local Legs = require 'Legs'
local PlateStack = require "PlateStack"

function Waiter:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
   
   self.radius = 9
   self.restitution = 0.4
   self.linearDamping = 1

	self.isApplyingForce = false
   self.mouse = {}
   self.mouse.x = 0
   self.mouse.y = 0
   

   self.legs = Legs:new(self)
   self.waiterbody = Sprite:new(self, "waiter.png", 35, 30)

   self.body      = lp.newBody(self.scene.world, x, y, "dynamic")
	self.shape     = lp.newCircleShape(self.radius)
	self.fixture   = lp.newFixture(self.body, self.shape)
	self.fixture:setRestitution(self.restitution)
   self.body:setLinearDamping(self.linearDamping)

   self.platestack = PlateStack:new(0, 0, self)
end

function Waiter:update(dt)
   
   if self.isApplyingForce then
      --[[ 
      -- Apply force in the direction of the mouse x,y
      --]]
      local px,py = self.body:getX(),self.body:getY()
      local mx,my = self.scene.cammgr.cam:worldCoords(love.mouse.getPosition())
      local dx,dy = mx-px,my-py
      self:applyForce(dx,dy) 
   end

   self.legs:update(dt)
   self.platestack:update(dt)
end

function Waiter:getTranslation()
   return self.body:getX(),self.body:getY(),vector.angleTo(self.body:getLinearVelocity())+math.pi/2
end

function Waiter:getVelocity()
	return self.body:getLinearVelocity()
end

function Waiter:draw()
	self.legs:draw()
	self.waiterbody:draw()
	self.platestack:draw()
   --lg.circle("fill", self.body:getX(), self.body:getY(), self.radius)
end

function Waiter:mousepressed(x, y, button)
   self.isApplyingForce = true
end

function Waiter:mousereleased(x, y, button)
   self.isApplyingForce = false
end

function Waiter:applyForce(x,y)
   self.body:applyForce(x,y)
end

function Waiter:keypressed(key, isrepeat)
	if key == " " then
		self.platestack:addPlate()
	end
end


return Waiter
