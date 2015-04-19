local GrissSystem = class("GrissSystem", Entity)

function GrissSystem:initialize(parent)
end

function GrissSystem:update(dt)
end

function GrissSystem:draw()
	love.graphics.draw(imgSrc, plates[self.pnum], self.body:getX(), self.body:getY(), self.rot, 1, 1, 8, 8)
end

return GrissSystem
