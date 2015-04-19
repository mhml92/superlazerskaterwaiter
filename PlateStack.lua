local PlateStack = class("PlateStack", Entity)

local Plate = require "Plate"

function PlateStack:initialize(x, y, parent)
	Entity.initialize(self, 0, 0, parent.scene)
	self.parent = parent

	self.stack = {}
	self.pending = {}
	self.joint = {}
end

function PlateStack:addPlate(kind, px, py)
	local x, y, r = self.parent:getTranslation()
	local cx, cy = self:offset(0, 20, r)
	local xx = px or cx+x
	local yy = py or cy+y
	local newPlate = Plate:new(xx, yy, self.scene)

	table.insert(self.pending, newPlate)
end

function PlateStack:removePlate()
	if #self.stack > 0 then
		table.remove(self.stack, 1)
		return true
	end
	return false
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
	for i=#self.pending, 1, -1 do
		local tmp = self.pending[i]
		local tx, ty = cx+x, cy+y
		local dx, dy = (cx+x-tmp.x), (cy+y-tmp.y)
		if #self.stack > 0 then
			local t = self.stack[#self.stack]
			tx, ty = t.x, t.y
			dx, dy = (tx-tmp.x), (ty-tmp.y)
		end
		local dist = math.sqrt(dx^2+dy^2)
		if dist <= 5 then
			tmp.x = tx
			tmp.y = ty
			table.insert(self.stack, table.remove(self.pending, i))
		else
			local lx, ly = dx/dist, dy/dist
			tmp.x = tmp.x+5*lx
			tmp.y = tmp.y+5*ly
		end
	end
end

function PlateStack:draw()
	local size = #self.stack
	for i=1,#self.stack do
		local intensity = 150-(i/size)*150
		self.stack[i]:draw(intensity)
	end
	for i=1,#self.pending do
		self.pending[i]:draw(0)
	end
end

return PlateStack
