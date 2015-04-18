local Plate = class("Plate", Entity)

local imgSrc = Resources.static:getImage("dirty_plates.png")
local quad = {}
for i=1,3 do
	quad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

function Plate:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
	self.ox = love.math.random(6)-3
	self.oy = love.math.random(6)-3
	self.quad = quad[1]
end

function Plate:draw(intensity)
	love.graphics.draw(imgSrc, self.quad, self.x+self.ox, self.y+self.oy)
	love.graphics.setColor(0, 0, 0, intensity)
	love.graphics.draw(imgSrc, self.quad, self.x+self.ox, self.y+self.oy)
	love.graphics.setColor(255, 255, 255, 255)
end

return Plate
