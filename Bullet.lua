local Bullet = class("Bullet", Entity)

local imgSrc = Resources.static:getImage("dirty_plates.png")
local plates = {}
for i = 1,3 do
   plates[i] = love.graphics.newQuad((i-1)*16,0,16,16,48,16)
end


function Bullet:initialize(parent)
   local px,py,pr = parent:getTranslation()
   local cx,cy = self:offset(15,-17,pr)
	Entity.initialize(self, cx+px, cy+py, parent.scene)
   
   self.dir = pr
   self.radius = 8
   self.force = 100
   self.rot = love.math.random()*2*math.pi
   self.deltaRot = (love.math.random()*math.pi/16) - ((love.math.random()*math.pi/16)/2)
   
   self.body      = lp.newBody(self.scene.world, x, y, "dynamic")
	self.shape     = lp.newCircleShape(self.radius)
	self.fixture   = lp.newFixture(self.body, self.shape)

   self.body:setBullet(true)
   self.fixture:setSensor(true)
   self.body:setLinearDamping(0)
   self.body:applyLinearImpulse(self.force*math.cos(pr),math.force*math.sin(pr))
	self.parent = parent
end

function Bullet:offset(x, y, r)
	local cx = x * math.cos(r) - y * math.sin(r)
	local cy = x * math.sin(r) + y * math.cos(r)
	return cx, cy
end

function Bullet:update(dt)
   self.rot self.rot + self. deltaRot
end

function Bullet:draw()
   local pnum = love.math.random()*3
	love.graphics.draw(imgSrc, plates[pnum], x, y, self.rot, 1, 1, 17, 25)
end

return Bullet
