local Waiter = class("Waiter", Entity)
local lg = love.graphics
local lp = love.physics

local Legs = require 'Legs'
local PlateStack = require "PlateStack"
local PlateGun = require "PlateGun"
local imgSrc = Resources.static:getImage("waiter.png")
local quad = {}
for i=0,7 do
	quad[i] = love.graphics.newQuad(i*70, 0, 70, 60, 560, 60)
end
local imgFood = Resources.static:getImage("dinner_plates.png")
local quadFood = {}
for i=1,3 do
	quadFood[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

local OFFX = {-22, -28, -13}
local OFFY = {-23, -10, -10}


function Waiter:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)
   
   self.radius = 9
   self.restitution = 0.4
   self.linearDamping = 0.8
   self.maxSpeed = 200
   self.acc = 3

   self.dishes = {0,0,0}
   self.pending = {nil, nil, nil}
   self.dishCount = 0

	self.isApplyingForce = false
   self.mouse = {}
   self.mouse.x = 0
   self.mouse.y = 0
   
   self.lookDir = 0
   
   self.img = {}
   self.img.shadow    = Resources.static:getImage("shadow.png")

   self.legs = Legs:new(self)

   self.body      = lp.newBody(self.scene.world, x, y, "dynamic")
	self.shape     = lp.newCircleShape(self.radius)
	self.fixture   = lp.newFixture(self.body, self.shape)
   self.fixture:setUserData(self)
	self.fixture:setRestitution(self.restitution)
   self.body:setLinearDamping(self.linearDamping)

   self.platestack = PlateStack:new(0, 0, self)
   self.plategun = PlateGun:new(0,0,self)

   self.step = 0
   self.isShooting = false
   self.ready = false

end

function Waiter:update(dt)
   local x, y, r = self:getTranslation()
   r = self.lookDir
	for i=1, 3 do
		if self.pending[i] and self.pending[i]:isActive() then
			local cx, cy = self:offset(OFFX[i], OFFY[i], r)
			local tmp = self.pending[i]
			local tx, ty = cx+x, cy+y
			local dx, dy = (cx+x-tmp.x), (cy+y-tmp.y)
			local dist = math.sqrt(dx^2+dy^2)
			if dist <= 5 then
				tmp.x = tx
				tmp.y = ty
				self.dishes[i] = tmp.kind
				self.pending[i]:setActive(false)
				--self.pending[i] = nil
			else
				local lx, ly = dx/dist, dy/dist
				tmp.x = tmp.x+5*lx
				tmp.y = tmp.y+5*ly
			end
		end
	end
   
   if self.maxSpeed < 200 then
      self.maxSpeed = (self.maxSpeed+0.01)*2 
      if self.maxSpeed > 200 then self.maxSpeed = 200 end
   end


   if self.isApplyingForce then
      --[[ 
      -- Apply force in the direction of the mouse x,y
      --]]
      local px,py = self.body:getX(),self.body:getY()
      local mx,my = self.scene.cammgr.cam:worldCoords(love.mouse.getPosition())
      local dx,dy = (mx-px)*self.acc,(my-py)*self.acc
      --[[
      if vector.len(dx,dy) > self.maxSpeed then
         dx,dy = vector.normalize(dx,dy)
         dx,dy = dx*self.maxSpeed,dy*self.maxSpeed
      end
      ]]
      self:applyForce(dx,dy) 

   end
      if vector.len(self.body:getLinearVelocity()) > self.maxSpeed then
         local vx,vy = self.body:getLinearVelocity()
         vx,vy = vector.normalize(vx,vy)
         self.body:setLinearVelocity(vx*self.maxSpeed,vy*self.maxSpeed)
      end


      --if self.isShooting then
         local sx,sy,sr = self:getTranslation()
         local mx,my = self.scene.cammgr.cam:worldCoords(love.mouse.getPosition())
         sx,sy = sx-mx,sy-my
         self.lookDir = vector.angleTo(sx,sy)- math.pi/2
      --else
         --self.lookDir = vector.angleTo(self.body:getLinearVelocity())+math.pi/2
      --end

   self.legs:update(dt)
   self.platestack:update(dt)
   self.x,self.y = self.body:getPosition()

   if love.mouse.isDown("r") then
      if self.ready then

         -- play sound
         local sound = "plategun/pop.mp3"
         local sndSrc = Resources.static:getSound(sound)
         sndSrc:setVolume(1)
         sndSrc:play()
         self.ready = false	
         self.isShooting = false
         self.plategun:shoot()
         self.scene.cammgr:shake(0.9,2)
         self.step = 0
      end
      if self.isShooting == false then
         if self.platestack:removePlate() then

            -- play sound
            local sound = "plategun/slurp.mp3"
            local sndSrc = Resources.static:getSound(sound)
            sndSrc:setVolume(1)
            sndSrc:play()


            self.isShooting = true
            Timer.tween(0.3, self, {step = 8}, "in-linear",
            function()
               self.step = 7
               self.ready = true
            end
            )
         end
      end

   end


end

function Waiter:offset(x, y, r)
	local cx = x * math.cos(r) - y * math.sin(r)
	local cy = x * math.sin(r) + y * math.cos(r)
	return cx, cy
end

function Waiter:getTranslation()
   return self.body:getX(),self.body:getY(),vector.angleTo(self.body:getLinearVelocity())+math.pi/2
end

function Waiter:getVelocity()
	return self.body:getLinearVelocity()
end

function Waiter:draw()
	self.legs:draw()
	local frame = math.min(7, math.floor(self.step))
	local x, y, r = self:getTranslation()
   love.graphics.draw(self.img.shadow,x,y,0,1.3,1.3,16,16)
	love.graphics.draw(imgSrc, quad[frame], x, y, self.lookDir, 1, 1, 35, 30)
	self.platestack:draw()
	for i=1,3 do
		if self.dishes[i] > 0 then
			local cx, cy = self:offset(OFFX[i], OFFY[i], self.lookDir)
			love.graphics.draw(imgFood, quadFood[self.dishes[i]], cx+x-8, cy+y-8)
			
		end
	end
end

function Waiter:mousepressed(x, y, button)
   if button == "l" then
      self.isApplyingForce = true
	  self.legs.accelerating = true
   end
   if button == "r" then

   end
end

function Waiter:mousereleased(x, y, button)
   if button == "l" then
      self.isApplyingForce = false
	  self.legs.accelerating = false
  elseif button == "r" then
  end
end

function Waiter:applyForce(x,y)
   self.body:applyForce(x,y)


end

function Waiter:givePlate(plate)
	for i=1, 3 do
		if self.pending[i] == nil then
			self.pending[i] = plate
			self.scene:addEntity(plate)
			self.dishCount = self.dishCount + 1
			return
		end
	end	
end

function Waiter:placePlate()
	local tmp = 0
	for i=1,3 do
		if self.dishes[i] > 0 then
			tmp = self.dishes[i]
			self.dishes[i] = 0
			self.pending[i]:kill()
			self.pending[i] = nil
			self.dishCount = self.dishCount - 1
			break
		end
	end
	return tmp
end


function Waiter:keypressed(key, isrepeat)
	if key == " " then
		self.platestack:addPlate()
	elseif key == "r" then
		--self.platestack:removePlate()
		self.dishes[1] = 0
	end
end


return Waiter
