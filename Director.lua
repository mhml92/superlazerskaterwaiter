local Customer = require "entities/Customer"

local Director = class("Director", Entity)

function Director:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)

	self.customers = {}
	self.waiting = {}
	self.step = 0
	self.level = self.scene.level
	self.chairs = self.level.chairs
end

function Director:update(dt)
	self.step = self.step + dt
	if self.step > 4 then
		-- add customer to scene
		local tmp = self.scene:addEntity(Customer:new(0, 0, self.scene, math.random(0,12)))
		
		--[[
		-- attempt to find empty chair
		local chair = self:getEmptyChair()
		if chair then
			-- Found an empty chair
			tmp:navigate(chair.i, chair.j)
			chair:occupy()
		else		
			-- get empty tile
			local r, c = self.level:getEmptyTile()
			tmp:navigate(r, c)
		end
		]]
		local r, c = self.level:getEmptyTile()
		tmp:navigate(r, c)
		table.insert(self.waiting, tmp)
		self.step = 0
	end
end

function Director:draw()

end

function Director:keypressed(key, isrepeat)
	if key == "q" then
		local customer = table.remove(self.waiting, 1)
		local chair = self:getEmptyChair()
		if chair then
			-- Found an empty chair
			customer:goToChair(chair)
			chair:occupy()
		end
	end
end

function Director:getEmptyChair()
	local base = love.math.random(1, #self.chairs)
	for i=base,#self.chairs do
		local chair = self.chairs[i]
		if chair.occupied == false then
			return chair
		end
	end
	for i=1,base-1 do
		local chair = self.chairs[i]
		if chair.occupied == false then
			return chair
		end
	end
	return nil
end

return Director
