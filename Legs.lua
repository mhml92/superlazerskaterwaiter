local Legs = class("Legs", Sprite)

function Legs:initialize(parent)
	Sprite.initialize(self, parent, "legs.png")
	self.quad = {}
	for i=0,11 do
		self.quad[i] = love.graphics.newQuad(i*34, 0, 34, 50, 408, 50)
	end
	self.step = 0
end

function Legs:update(dt)
	self.step = self.step + 5*dt
end

function Legs:draw()
	local frame = math.floor(step%12)
	local x, y, r = self.parent:getTranslation()
	love.graphcis(quad[frame], x, y, r, 2, 2, 17, 25)
end

return Legs
