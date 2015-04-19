local PlateDispensor = class("PlateDispensor", Entity)

local LIMIT = 15
local COOLDOWN = 2

function PlateDispensor:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
	self.radius = 100
	self.radiusSq = self.radius*self.radius
	self.waiter = scene.waiter
	self.step = 0
	self.count = LIMIT
	self.cooldown = COOLDOWN
end

function PlateDispensor:update(dt)
	self.cooldown = self.cooldown - dt
	if self.cooldown <= 0 then
		if self.count < LIMIT then
			self.count = self.count + 1
		end
		self.cooldown = COOLDOWN
	end
	if self.step == 0 then
		local x, y, r = self.waiter:getTranslation()
		local dx, dy = x-self.x, y-self.y
		local dist = dx*dx+dy*dy
		if self.count > 0 and dist < self.radiusSq then
			self.waiter.platestack:addPlate(love.math.random(1,3), self.x, self.y)
			self.count = self.count - 1
			self.step = 0.2
		end
	else
		self.step = self.step - dt
		if self.step <= 0 then self.step = 0 end
	end
end

function PlateDispensor:draw()
	love.graphics.circle("line", self.x, self.y, self.radius)
	love.graphics.print("Count = "..self.count, self.x, self.y+20)
end

return PlateDispensor
