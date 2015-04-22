local Customer = require "entities/Customer"

local Director = class("Director", Entity)

function Director:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)

	self.customers = {}
	self.waiting = {}
	self.step = 0
	self.level = self.scene.level
	self.chairs = self.level.chairs
   self.spawnTime = 2
   self.spawnTimeMin = 1.5
end

function Director:update(dt)

	self.step = self.step + dt
	if self.step > self.spawnTime then
		-- add customer to scene
		local tmp = self.scene:addEntity(Customer:new(0, 0, self.scene, math.random(0,12)))
		
		-- attempt to find empty chair
		local chair = self:getEmptyChair()
		if chair then
			-- Found an empty chair
			tmp:goToChair(chair)
			chair:occupy()
		else		
			-- get empty tile
			local r, c = self.level:getEmptyTile()
			tmp:navigate(r, c)
			table.insert(self.waiting, tmp)
		end
		--local r, c = self.level:getEmptyTile()
		--tmp:navigate(r, c)
		self.step = 0
	else
		self:lol()
	end
      self.spawnTime = self.spawnTime - dt/120
      if self.spawnTime < self.spawnTimeMin then
         self.spawnTime = self.spawnTimeMin    
      end
end

function Director:draw()

end

function Director:lol()
	if #self.waiting == 0 then return end
	local customer = table.remove(self.waiting, 1)
	local chair = self:getEmptyChair()
	if chair then
		-- Found an empty chair
		customer:goToChair(chair)
		chair:occupy()
	end
end

function Director:keypressed(key, isrepeat)
end

function Director:getEmptyChair()
	local base = love.math.random(1, #self.chairs)
	for i=base,#self.chairs do
		local chair = self.chairs[i]
		if chair.occupied == false then
			if chair.table and chair.table.plate == 0 and chair.table.done == false then
				return chair
			end
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
