local Table = class("Table", Entity)

local lg = love.graphics
local lp = love.physics

function Table:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
   self.body = lp.newBody(self.scene.world,x,y,"static")
   self.shape = lp.newRectangleShape(SquareSize,SquareSize)
   self.fixture = lp.newFixture(self.body,self.shape)
   self.fixture:setUserData(self)
   self.img = {}
   self.img.table = Resources.static:getImage("table.png")
   self.img.shadow    = Resources.static:getImage("shadow.png")
   
   self.plate = 0
   self.order = 0
end

function Table:setOrder(i)
  self.order = i 
end

function Table:update(dt)
   local x,y,r = self.scene.waiter:getTranslation()
   if vector.len(self.x,self.y,x,y) < 48 then
      if self.scene.waiter:hasDish(self.order) then
         self.plate = self.scene.waiter:getDish(self.order)
      end
   end

end


function Table:addPlate()
end

function Table:draw()
   lg.draw(self.img.shadow,self.x,self.y,0,1.3,1.3,16,16)
   lg.draw(self.img.table,self.x-16,self.y-16)

   --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
return Table
