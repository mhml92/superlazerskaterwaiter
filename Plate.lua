local Plate = class("Plate", Entity)

function Plate:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
	self.ox = love.math.random(6)-3
	self.oy = love.math.random(6)-3
end

function Plate:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", self.x+self.ox, self.y+self.oy, 8)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("line", self.x+self.ox, self.y+self.oy, 8)
	love.graphics.setColor(255, 255, 255)
end

return Plate
