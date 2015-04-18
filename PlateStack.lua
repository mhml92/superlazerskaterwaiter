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
		local newPlate = Plate:new(x+math.cos(r)*100, y+math.sin(r)*100, self.scene)
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

function PlateStack:update(dt)
	local x, y, r = self.parent:getTranslation()
	local dx, dy
	if #self.stack > 0 then
		local bottom = self.stack[1]
		bottom.x = (x+math.cos(r)*100)
		bottom.y = (y+math.sin(r)*100)
	end
end

function PlateStack:draw()
end

return PlateStack
