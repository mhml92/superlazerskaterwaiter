local Diner = class("Diner", Scene)

local Waiter   = require "entities/Waiter"
local Level    = require "entities/Level"
local CameraManager = require "CameraManager"
local Customer = require "entities/Customer"
local SpeechBubble = require "SpeechBubble" 
local Collision   = require 'Collision'
local PlateDispensor = require "PlateDispensor"
local Director = require "Director"
local GrissSystem = require "GrissSystem"
local FoodDispensor = require "FoodDispensor"

local METER = SquareSize

function Diner:initialize()
   Scene.initialize(self)
   
   love.physics.setMeter(METER)
   self.world = love.physics.newWorld(0,0, true)
   self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

   self.collision = Collision:new(self)

   self.level = Level:new(0,0,"level0.lvl",self)
   self.cammgr = CameraManager:new(self)

   self.waiter = self:addEntity(Waiter:new(400, 100, self))

   self.plateDispensor = self:addEntity(PlateDispensor:new(12*SquareSize, 15*SquareSize, self))
	self.foodDispensor = self:addEntity(FoodDispensor:new(0, 12*32, self))

   self.director = self:addEntity(Director:new(0,0,self))

   self.gris = GrissSystem:new(self) 

   self.playTime = 0

   self.money = 0
   self.damage = 0
   self.test = 200
end

function Diner:gameOver()
   print(fdf)
end

function Diner:addMoney()
   self.money = self.money +10
end

function Diner:addDamage()

   local sound = "boo.mp3"
   local sndSrc = Resources.static:getSound(sound)
   sndSrc:setVolume(0.6)
   sndSrc:play()
   self.damage = self.damage +1
   if self.damage == 5 then
      endGame()
   end

end


function Diner:update(dt)
   self.playTime = self.playTime + dt
	Timer.update(dt)

   --self.cammgr:update(self.level.width/2,self.level.height/2)
   self.cammgr:update(self.waiter.x,self.waiter.y)
	self.world:update(dt)
   self.gris:update(dt)
   self.level:update(dt)
	Scene.update(self, dt)
end

function Diner:draw()
   self.cammgr:attach()
   self.level:draw()
   self.gris:draw()
	Scene.draw(self)



   local mx,my = self.cammgr.cam:worldCoords(love.mouse.getPosition())
   love.graphics.draw(Resources:getImage("aim.png"),mx,my,0, 1, 1, 16, 16)
   self.cammgr:detach()
end

function Diner:keypressed(key, isrepeat)
	if key == "s" then
		self.test = self:addEntity(Customer:new(0, 0, self))
		self.test:navigate(6, 3)
	elseif key == "t" then
		local t = self:addEntity(SpeechBubble:new(self.test, 200, self))
		self.test = self.test + 40
		local f = love.math.random(1,3)
		t:requestFood(f)
		t:spawn()
	end
	Scene.keypressed(self, key, isrepeat)
end

function Diner:beginContact(a,b,coll)
   self.collision:resolve(a,b,coll)
end

function Diner:endContact(a,b,coll)
end

function Diner:preSolve(a,b,coll)
end

function Diner:postSolve(...)
end


return Diner
