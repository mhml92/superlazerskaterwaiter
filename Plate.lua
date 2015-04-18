local Plate = class("Plate", Entity)

function Plate:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
end

function Plate:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", self.x, self.y, 16)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("line", self.x, self.y, 16)
	love.graphics.setColor(255, 255, 255)
end

return Plate
