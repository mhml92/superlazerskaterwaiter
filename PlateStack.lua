local PlateStack = class("PlateStack", Entity)

local Plate = require "Plate"

function PlateStack:initialize(x, y, parent)
	Entity.initialize(self, 0, 0, parent.scene)
	self.parent = parent

	self.stack = {}
	self.joint = {}

end

function PlateStack:addPlate()
	local x, y, r = self.parent:getTranslation()
	local cx, cy = self:offset(x, y, r)
	local newPlate = Plate:new(cx, cy, self.scene)
	table.insert(self.stack, newPlate)
end

function PlateStack:removePlate()

end

function PlateStack:offset(x, y, r)
	local cx = x-math.cos(r)*40
	local cy = y-math.sin(r)*40
	return cx, cy
end

function PlateStack:update(dt)
	local x, y, r = self.parent:getTranslation()
	local cx, cy = self:offset(x, y, r)
	if #self.stack > 0 then
		local bottom = self.stack[1]
		bottom.x = cx
		bottom.y = cy
	end
	local lx, ly = cx, cy
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
	for i=1,#self.stack do
		self.stack[i]:draw()
	end
end

return PlateStack
