local Customer = require "entities/Customer"

local Director = class("Director", Entity)

function Director:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)

	self.customers = {}
	self.step = 0
	self.level = self.scene.level
	self.chairs = self.level.chairs
end

function Director:update(dt)
	self.step = self.step + dt
	if self.step > 4 then
		local tmp = self.scene:addEntity(Customer:new(0, 0, self.scene, math.random(0,8)))
		tmp:navigate(math.random(1,15), math.random(1,18))
		self.step = 0
	end
end

function Director:draw()

end

return Director
