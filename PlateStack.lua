local PlateStack = class("PlateStack", Entity)

local Plate = require "Plate"

function PlateStack:initialize(x, y, parent)
	Entity.initialize(self, 0, 0, parent.scene)
	self.parent = parent

	self.stack = {}
	self.joint = {}

end

function PlateStack:addPlate()
	if #self.stack == 0 then
		local x, y, r = self.parent:getTranslation()
		local cx, cy = self:offset(17, 0, r)
		local newPlate = Plate:new(x+cx,y+cy, self.scene)
		self.scene:addEntity(newPlate)
		table.insert(self.stack, newPlate)
	else
		local upper = self.stack[#self.stack]
		local x, y = upper.x, upper.y
		local newPlate = Plate:new(x, y, self.scene)
		self.scene:addEntity(newPlate)
		table.insert(self.stack, newPlate)
		local n = newPlate.body
	end
end

function PlateStack:removePlate()

end

function PlateStack:offset(x, y, r)
	local cx = x * math.cos(r) - y * math.sin(r)
	local cy = x * math.sin(r) + y * math.cos(r)
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
end

return PlateStack
