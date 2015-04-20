local BrokenPlate = class("BrokenPlate",Entity)
local piecesSrc = Resources.static:getImage("broken_plate.png")

local lp = love.physics

local pieces = {} 
for i = 1,3 do
   pieces[i] = love.graphics.newQuad((i-1)*16,0,16,16,48,16)
end

function BrokenPlate:initialize(ptype,x,y,vx,vy,scene)
   Entity.initialize(self,x,y,scene)

   self.flags = {}
   self.flags.firstUpdate = true
   self.r = 0--math.pi*2*math.random()
   self.time = 60 
   self.radius = 3
   self.quad = ptype
   
   if ptype == 1 then
      self.offsetx = 3
      self.offsety = -3
   elseif ptype == 2 then
      self.offsetx = -3
      self.offsety = -3
   elseif ptype == 3 then
      self.offsetx = 3
      self.offsety = 3
   end
   self.vx = vx
   self.vy = vy

end

function BrokenPlate:update(dt)
   if self.flags.firstUpdate then
      self.flags.firstUpdate = false
      self.body      = lp.newBody(self.scene.world, self.x+self.offsetx, self.y+self.offsety, "dynamic")
      self.shape     = lp.newCircleShape(self.radius)
      self.fixture   = lp.newFixture(self.body, self.shape)
      self.fixture:setRestitution(1)
      self.body:setMass(0)
      local pspeed = 100
      local noiseAngle = (2*math.pi*math.random())
      local nx,ny = math.cos(noiseAngle),math.sin(noiseAngle)
      --local rx,ry = vector.normalize(self.vx+nx,self.vy+ny)
      self.body:setLinearVelocity(pspeed*nx,pspeed*ny)
      --self.body:setLinearDamping(0.9)
      self.body:setAngularDamping(0.9)
      --self.body:applyLinearImpulse(self.vx/1000,self.vy/1000)
      return

   end
      self.fixture:setSensor(true)
   if self.time < 0 then
      self.body:setActive(false) 
   else
      self.time = self.time -1 
   end
end


function BrokenPlate:draw()
	if not self.flags.firstUpdate then
   love.graphics.draw(piecesSrc, pieces[self.quad], self.body:getX(), self.body:getY(), self.body:getAngle(),1, 1, 8+self.offsetx, 8+self.offsety)
end

end

return BrokenPlate
