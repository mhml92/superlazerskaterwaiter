local Bullet = class("Bullet", Entity)

local lp = love.physics
local imgSrc = Resources.static:getImage("dirty_plates.png")
local piecesSrc = Resources.static:getImage("broken_plate.png")
local plates = {}
for i = 1,3 do
   plates[i] = love.graphics.newQuad((i-1)*16,0,16,16,48,16)
end


function Bullet:initialize(parent)
   local px,py,pr = parent:getTranslation()
   pr = parent.lookDir
   local cx,cy = self:offset(15,-17,pr)
	Entity.initialize(self, cx+px, cy+py, parent.scene)
   self.lvx = 0
   self.lvy = 0
   self.dir = pr - math.pi/2
   self.radius = 8
   self.force = 100
   self.rot = math.random()*2*math.pi
   self.deltaRot = (love.math.random()*math.pi/16) - ((love.math.random()*math.pi/16)/2)
  
   self.body      = lp.newBody(self.scene.world, self.x, self.y, "dynamic")
	self.shape     = lp.newCircleShape(self.radius)
	self.fixture   = lp.newFixture(self.body, self.shape)
   self.fixture:setUserData(self)

   self.body:setBullet(true)
   self.fixture:setSensor(true)
   self.body:setLinearDamping(0)
   self.body:applyLinearImpulse(self.force*math.cos(self.dir),self.force*math.sin(self.dir))
	self.parent = parent
   
   self.pnum = math.floor(math.random()*(3-0.001))+1
   self.scene = parent.scene
end

function Bullet:offset(x, y, r)
	local cx = x * math.cos(r) - y * math.sin(r)
	local cy = x * math.sin(r) + y * math.cos(r)
	return cx, cy
end

function Bullet:update(dt)
   self.rot =  self.rot + self.deltaRot*dt
   self.x = self.body:getX()
   self.y = self.body:getY()
   self.lvx,self.lvy = self.body:getLinearVelocity()
end

function Bullet:draw()
	love.graphics.draw(imgSrc, plates[self.pnum], self.body:getX(), self.body:getY(), self.rot, 1, 1, 8, 8)
end

function Bullet:exit()
   -- screenshake
   self.scene.cammgr:shake(0.9,2)


   -- play sound
   local num = love.math.random(1,5)   
   local sound = "plates/plates"..num..".mp3"
   local sndSrc = Resources.static:getSound(sound)
   sndSrc:setVolume(0.2)
   sndSrc:play()
   self:kill()

   

end


return Bullet
