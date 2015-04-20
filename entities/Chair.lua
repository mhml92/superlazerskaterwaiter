
local Chair = class("Chair", Entity)

local lg = love.graphics
local lp = love.physics

function Chair:initialize(x, y, scene, i, j)
	Entity.initialize(self, x, y, scene)
   self.img = {}
   self.img.shadow    = Resources.static:getImage("shadow.png")
   self.img.chair    = Resources.static:getImage("chair.png")
   self.occupied = false
   self.i = i
   self.j = j
end

function Chair:occupy()
	self.occupied = true
end

function Chair:leave()
	self.occupied = false
end

function Chair:draw()
   lg.draw(self.img.shadow,self.x,self.y,0,1.3,1.3,16,16)
   lg.draw(self.img.chair,self.x-16,self.y-16)
   --love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Chair