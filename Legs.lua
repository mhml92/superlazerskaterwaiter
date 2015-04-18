local Legs = class("Legs")

local src = love.graphics.newImage("legs.png")
local quad = {}
for i=0,11 do
	quad[i] = love.graphics.newQuad(i*34, 0, 34, 50, 408, 50)
end

function Legs:initialize(parent)
	self.parent = parent
	self.step = 0
end

function Legs:update(dt)
	self.step = self.step + 10*dt

end

function Legs:draw()
	local frame = math.floor(self.step%12)
	local x, y, r = self.parent:getTranslation()
	love.graphics.draw(src,quad[frame], x, y, r, 1, 1,17,25)
end

return Legs
