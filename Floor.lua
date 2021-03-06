local Floor = class("Bound", Entity)

local phys = love.physics

function Floor:initialize(x, y, w, h, scene)
	Entity.initialize(self, x, y, scene)
	self.width, self.height = w, h
	self.body = phys.newBody(self.scene.world, x+(self.width/2), y+(self.height/2), "static")
	self.shape = phys.newRectangleShape(w, h)
	self.fixture = phys.newFixture(self.body, self.shape)
   self.fixture:setUserData(self)
end
function Floor:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end
return Floor
