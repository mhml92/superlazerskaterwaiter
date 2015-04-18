local PlateGun = class("PlateGun", Entity)


function PlateGun:initialize(x, y, parent)
	Entity.initialize(self, 0, 0, parent.scene)
	self.parent = parent

end

function PlateStack:offset(x, y, r)
	local cx = x * math.cos(r) - y * math.sin(r)
	local cy = x * math.sin(r) + y * math.cos(r)
	return cx, cy
end

function PlateStack:update(dt)
	local x, y, r = self.parent:getTranslation()
	local cx, cy = self:offset(0, 20, r)
	if #self.stack > 0 then
		local bottom = self.stack[1]
		bottom.x = cx+x
		bottom.y = cy+y
	end
	local lx, ly = cx+x, cy+y
	for i=2,#self.stack do
		local current = self.stack[i]
		local dx, dy = lx-current.x, ly-current.y
		local ddx, ddy = 0.75*dx, 0.75*dy
		current.x = current.x+ddx
		current.y = current.y+ddy
		lx, ly = current.x, current.y
	end
end

function PlateStack:draw()
	local size = #self.stack
	for i=1,#self.stack do
		local intensity = 150-(i/size)*150
		self.stack[i]:draw(intensity)
	end
end

return PlateStack
