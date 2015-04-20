local Table = class("Table", Entity)

local lg = love.graphics
local lp = love.physics

local foodSrc = Resources.static:getImage("dinner_plates.png")
local dirtySrc = Resources.static:getImage("dirty_plates.png")
local foodQuad = {}
for i=1,3 do 
	foodQuad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

function Table:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
   self.body = lp.newBody(self.scene.world,x,y,"static")
   self.shape = lp.newRectangleShape(SquareSize,SquareSize)
   self.fixture = lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
   self.img = {}
   self.img.table = Resources.static:getImage("table.png")
   self.img.shadow    = Resources.static:getImage("shadow.png")
   
   self.ox = love.math.random(0,6)-3
   self.oy = love.math.random(0,6)-3

   self.plate = love.math.random(1,3)
   self.order = 0
   self.done = true
end

function Table:setOrder(i)
  self.order = i 
end

function Table:update(dt)
   local x,y,r = self.scene.waiter:getTranslation()
   local dx, dy = self.x-x, self.y-y
   if (dx*dx+dy*dy) < 48*48 then
      if self.plate > 0 then
		self.scene.waiter.platestack:addPlate(self.plate, self.x-8+self.ox, self.y-8+self.oy, self.plate)
		self.plate = 0
	  elseif self.scene.waiter:hasDish(self.order) then
         self.plate = self.scene.waiter:getDish(self.order)
      end
   end

end


function Table:addPlate()
end

function Table:finishEating()
	self.done = true
end

function Table:draw()
   lg.draw(self.img.shadow,self.x,self.y,0,1.3,1.3,16,16)
   lg.draw(self.img.table,self.x-16,self.y-16)
	if self.plate > 0 then
		if self.done then
			lg.draw(dirtySrc, foodQuad[self.plate], self.x-8+self.ox, self.y-8+self.oy)
		else
  			 lg.draw(foodSrc, foodQuad[self.plate], self.x-8+self.ox, self.y-8+self.oy)
   		end
   end
   --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
return Table
