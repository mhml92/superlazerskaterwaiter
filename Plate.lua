local Plate = class("Plate", Entity)

local imgSrc = Resources.static:getImage("dirty_plates.png")
local quad = {}
for i=1,3 do
	quad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end
local imgFood = Resources.static:getImage("dinner_plates.png")
local quadFood = {}
for i=1,3 do
	quadFood[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

function Plate:initialize(x, y, scene, kind, dirty)
	Entity.initialize(self, x, y, scene)
	self.ox = love.math.random(6)-3
	self.oy = love.math.random(6)-3
	self.kind = kind or love.math.random(1,3)
	self.dirty = dirty
end

function Plate:draw(intensity)
	if self.kind <= 0 then return end
	if self.dirty then
		love.graphics.draw(imgSrc, quad[self.kind], self.x+self.ox-8, self.y+self.oy-8)
		love.graphics.setColor(0, 0, 0, intensity)
		love.graphics.draw(imgSrc, quad[self.kind], self.x+self.ox-8, self.y+self.oy-8)
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.draw(imgFood, quadFood[self.kind], self.x+self.ox-8, self.y+self.oy-8)
	end
end

function Plate:exit()
end


return Plate
