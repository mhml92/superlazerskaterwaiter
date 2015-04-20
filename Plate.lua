local Plate = class("Plate", Entity)

local imgSrc = Resources.static:getImage("dirty_plates.png")
local quad = {}
for i=1,3 do
	quad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

function Plate:initialize(x, y, scene, kind)
	Entity.initialize(self, x, y, scene)
	self.ox = love.math.random(6)-3
	self.oy = love.math.random(6)-3
	self.kind = kind or love.math.random(1,3)
end

function Plate:draw(intensity)
	love.graphics.draw(imgSrc, quad[self.kind], self.x+self.ox-8, self.y+self.oy-8)
	love.graphics.setColor(0, 0, 0, intensity)
	love.graphics.draw(imgSrc, quad[self.kind], self.x+self.ox-8, self.y+self.oy-8)
	love.graphics.setColor(255, 255, 255, 255)
end

return Plate
