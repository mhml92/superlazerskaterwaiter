local Info = require "Info"

local Clock = class("Clock", Info)

local imgSrc = Resources:getImage("clock.png")
local shadow = Resources.static:getImage("shadow.png")
local quad = {}
for i=0,8 do
	quad[i] = love.graphics.newQuad(i*16, 0, 16, 16, 144, 16)
end

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
	local frame = math.min(8, math.floor(self.clock/(LIMIT/9)))
   love.graphics.draw(shadow,self.x+8,self.y+8,0,0.7,0.7,16,16)
	love.graphics.draw(imgSrc, quad[frame], self.x, self.y, 0, self.scale, self.scale)
end

return Clock
