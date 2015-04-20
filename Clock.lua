local Info = require "Info"

local Clock = class("Clock", Info)

local LIMIT = 10

function Clock:initialize(x, y, scene)
	Info.initialize(self, x, y, scene)
	self.clock = 0
end

function Clock:update(dt)
	Info.update(self, dt)
	self.clock = self.clock + dt
end

function Clock:isOut()
	return self.clock >= LIMIT
end

function Clock:draw()
	love.graphics.setColor(255, 255,255 ,255)
	love.graphics.print(math.floor(self.clock), self.x, self.y)
end

return Clock