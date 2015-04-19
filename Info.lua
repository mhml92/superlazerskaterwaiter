local Info = class("Info", Entity)

function Info:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
	self.basey = self.y
	self.step = 0
	self.speed = 5
	self.oy = 0
	self.scale = 0
end

function Info:spawn()
	Timer.tween(0.5, self, {scale=1}, "out-back")
end

function Info:update(dt)
	self.step = self.step + self.speed*dt
	self.oy = 5*math.sin(self.step)
	self.y = self.basey + self.oy
end

function Info:draw()
	local s = 20*self.scale
	love.graphics.circle("fill", self.x, self.y, s)
end

return Info
