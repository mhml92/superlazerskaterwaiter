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
	self.step = self.step + 5*dt

end

function Legs:draw()
	local frame = math.floor(step%12)
	local x, y, r = self.parent:getTranslation()
	love.graphcis(quad[frame], x, y, r, 2, 2)
end

return Legs
