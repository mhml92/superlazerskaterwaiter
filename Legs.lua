local Legs = class("Legs", Sprite)

function Legs:initialize(parent)
	Sprite.initialize(self, parent, "legs.png")
	self.quad = {}
	for i=0,17 do
		self.quad[i] = love.graphics.newQuad(i*34, 0, 34, 50, 612, 50)
	end
	self.step = 0
	self.accelerating = false
end

function Legs:update(dt)
	if self.accelerating == false then
		local f = math.floor(self.step%18)
		if f == 0 or f == 9 then return end
	end
	local speed = 10
	self.step = self.step + speed*dt
end

function Legs:draw()
	local frame = math.floor(self.step%18)
	local x, y, r = self.parent:getTranslation()
	love.graphics.draw(self.src, self.quad[frame], x, y, r, 1, 1, 17, 25)
end

return Legs
