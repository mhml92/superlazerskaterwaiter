local FoodDispensor = class("PlateDispensor", Entity)

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
	for i=0,6 do
		self.slots[i] = love.math.random(1,3)
		print(self.slots[i])
	end
	self.step = 0
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
end

function FoodDispensor:draw()
	for i=0,4 do
		local offset = self.step*32
		local x = self.x+i*32+offset
		love.graphics.draw(imgPlate, quad[self.slots[i]], x, self.y)
	end
	for i=0,1 do
		local offset = self.step*32
		local y = self.y+i*32+offset
		love.graphics.draw(imgPlate, quad[self.slots[i+5]], self.x+(5*32), y)
	end
end

return FoodDispensor
