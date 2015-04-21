local FoodDispensor = class("PlateDispensor", Entity)

local Plate = require "Plate"

local imgHole = Resources:getImage("hole_gradient.png")

local imgConv = Resources:getImage("conveyor_belt.png")
local quadConv = {}
for i=0,3 do
	quadConv[i] = love.graphics.newQuad(0, i*64, 128, 64, 128, 256)
end

local imgPlate = Resources:getImage("dinner_plates.png")
local quad = {}
for i=1,3 do
	quad[i] = love.graphics.newQuad((i-1)*16,0,16,16,48,16)
end

local X = {0, 4*32, 4*32}
local Y = {8*32, 8*32, 10*32}

function FoodDispensor:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
	self.slots = {}
	for i=0,5 do
		self.slots[i] = love.math.random(1,3)
	end
	self.step = 0
	self.anistep = 0
end

function FoodDispensor:update(dt)
	self.step = self.step + dt
	if self.step >= 1 then
		self.step = 0
		for i=6,1,-1 do
			self.slots[i] = self.slots[i-1]
		end
		self.slots[0] = love.math.random(1,3)
	end
	self.anistep = self.anistep + 17*dt
	if self.anistep >= 4 then
		self.anistep = 0
	end


   local w = self.scene.waiter
   local lvl = self.scene.level
   if w.y > 11*SquareSize and w.x < 6*SquareSize then

		self:givePlate()
   end


end


function FoodDispensor:givePlate()
	if self.scene.waiter.dishCount < 3 then
		local i = love.math.random(0,5)
		while self.slots[i] == 0 do
			i = (i + 1)%6
		end
		local x, y = self.x+4*32+8, self.y+8 
		if i <= 3 then
			x = self.x+i*32+self.step*32+8
		else
			y = self.y+(i-4)*32+self.step*32+8
		end
		local plate = Plate:new(x, y, self.scene, self.slots[i], false)
		self.scene.waiter:givePlate(plate)
		self.slots[i] = 0
	end
end

function FoodDispensor:draw()
	local frame = math.floor(self.anistep)
	love.graphics.draw(imgConv, quadConv[frame], self.x+32, self.y)
	for i=0,3 do
		local offset = self.step*32
		local x = self.x+i*32+offset
		if self.slots[i] > 0 then
			love.graphics.draw(imgPlate, quad[self.slots[i]], x+8, self.y+8)
		end
	end
	for i=0,1 do
		local offset = self.step*32
		local y = self.y+i*32+offset
		if self.slots[i+4] > 0 then
			love.graphics.draw(imgPlate, quad[self.slots[i+4]], self.x+(4*32)+8, y+8)
		end
	end
	love.graphics.draw(imgHole, self.x, self.y)
	love.graphics.draw(imgHole, self.x+128, self.y+96, -math.pi/2)
end

function FoodDispensor:keypressed(key, isrepeat)
end

return FoodDispensor
