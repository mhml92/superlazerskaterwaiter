local Customer = class("Customer", Entity)

local SpeechBubble = require "SpeechBubble"
local Clock = require "Clock"

local imgSrc = Resources.static:getImage("persons.png")
local quads = {}
for i=0,8 do
	quads[i] = love.graphics.newQuad(i*32, 0, 32, 32, 288, 32)
end

local OUTSIDE = -1
local GOTO_CHAIR = 0
local WALK_WAIT = 1
local EATING = 3
local LEAVING = 4
local WAITING = 5
local OUT = 6

local HAPPY = 0
local ANGRY = 1

local WALKSPEED = 50

function Customer:initialize(x, y, scene, person)
	Entity.initialize(self, x, y, scene)


   self.width = 20
   self.height = 20
   self.radius = 10
	self.state = WALK_WAIT
	self.mood = HAPPY
	
	self.scale = 0
	Timer.tween(0.3, self, {scale = 1}, "out-back")
	
	self.clock = nil

	self.walking = true
	self.grid = self.scene.level.matrix
	self.w = self.scene.level.numTilesWidth
	self.h = self.scene.level.numTilesHeight
   
   self.wasWalking = true
   self.timerHandle = nil
   self.timerHandle2 = nil
	self.quad = quads[person]

	self.level = scene.level
   self.img = {}
   self.img.shadow    = Resources.static:getImage("shadow.png")

	self.lastx = self.x
	self.lasty = self.y
	self.angle = math.pi --math.random()*2*math.pi

   local phys = love.physics
	self.body = phys.newBody(self.scene.world, x, y, "dynamic")
	self.shape = phys.newCircleShape(self.radius)
	self.fixture = phys.newFixture(self.body, self.shape)
   self.fixture:setUserData(self)
   self.body:setBullet(true)
   self.body:setLinearDamping(0.8)
   self.fixture:setSensor(true)


	self.ti = self.level.doori
	self.tj = self.level.doorj
	self.tx = self.tj*32
	self.ty = self.ti*32
	self.x = self.tj*32
	self.y = -32

	self:walk(self.tx, self.ty)

	self.sitting = false
	self.chair = nil

	self.bubble = nil
end

function Customer:navigate(i, j)
	self.ti = i
	self.tj = j
end

function Customer:goToChair(chair)
	self.chair = chair
	if self.timerHandle2 then
		Timer.cancel(self.timerHandle2)
		self.sitting = false
	end
	self.state = GOTO_CHAIR
	self.ti = chair.i
	self.tj = chair.j
end

function Customer:walk(tx, ty)
	self.tx = tx
	self.ty = ty
	local dist = math.sqrt((tx-self.x)^2+(ty-self.y)^2)
	local t = dist/WALKSPEED
	self.walking = true
	self.timerHandle = Timer.tween(t, self, {x=tx, y=ty}, "in-linear", function()
			self.walking = false
		end
		)
end

function Customer:update(dt)
   if not self.fixture:isSensor() then
      local dx,dy = self.body:getLinearVelocity()
      if vector.len(dx,dy) < 40 then
         self.walking = false
         self.sitting = false
         self.fixture:setSensor(true)
         self.x,self.y = self.body:getX()+16,self.body:getY()+16
      end
   end

	-- check clock
	if self.clock and self.clock:isOut() then
		self.clock:kill()
		self.clock = nil
		self.state = LEAVING
		self.sitting = false
		self.walking = false
		if self.chair then self.chair:leave() end
		self:navigate(self.level.doori, self.level.doorj)
	end

	if self.sitting then return end
	if self.walking == false then
		local ci, cj = self:getGridCoord()
		if ci ~= self.ti or cj ~= self.tj then
			local bestScore = 1000000
			local besti = -1
			local bestj = -1
			for ii=-1,1 do
				for jj=-1,1 do
					if (ii==0 or jj==0) and ii~=jj then
						local cr, cc = ci+ii, cj+jj
						if cr >= 1 and cr <= 15 and cc >= 1 and cc <= 18 then
							local token = self.grid[cr][cc]
							if token == "0" or token == "16" or token == "7" then
								local dist = (self.ti-cr)^2 + (self.tj-cc)^2
								if dist < bestScore then
									bestScore = dist
									besti = cr
									bestj = cc
								end
							end
						end
					end
				end
         end
			if besti == -1 then
				return
			end
         self.angle = math.atan2((besti-ci),bestj-cj)+ math.pi/2
			self:walk(32*bestj, 32*besti)
		else
			self:arrived()
		end
   end
   --local ox,oy = self.body:getX(),self.body:getY()
   self.body:setX(self.x-16)
   self.body:setY(self.y-16)
   --if ox-(self.x-16) =~ 0 and oy-(self.y-16) =~0 then 
   --   self.angle = vector.angleTo(self.body:getX()-ox,self.body:getY()-oy) + math.pi/2
   --end
end

function Customer:leaveDiner()
	local tx = self.level.doorj*32
	local ty = -32
	local dist = math.sqrt((tx-self.x)^2+(ty-self.y)^2)
	local t = dist/WALKSPEED
	self.sitting = false
	self.walking = true
	Timer.tween(t, self, {y = ty}, "in-linear", function()
		Timer.tween(0.3, self, {scale = 0}, "in-back", function()
			self:exit()
		end)
	end)
end

function Customer:getGridCoord()
	local ci, cj = math.floor((self.y+16)/32), math.floor((self.x+16)/32)
	return ci, cj
end

function Customer:arrived()
	if self.state == WALK_WAIT then
		self.sitting = true
		local nr, nc = self.scene.level:getEmptyTile()
		local delay = love.math.random(3,10)
		self.timerHandle2 = Timer.add(delay, function()
			self.sitting = false
			self:navigate(nr, nc)
		end)
	elseif self.state == GOTO_CHAIR or self.state == WAITING then
		self.state = WAITING
		self.sitting = true
		
		if not self.clock then
			local r, c = self:getGridCoord()
			if r == self.chair.i or c == self.chair.j then
				self.clock = self.scene:addEntity(Clock:new(self.x-32, self.y-30, self.scene))
				self.clock:spawn()
			else
				self.state = LEAVING
				self.sitting = false
				self.walking = false
				if self.chair then self.chair:leave() end
				self:navigate(self.level.doori, self.level.doorj)
			end
		end
		
		-- turn the right way
		local ci, cj = math.floor((self.y+16)/32), math.floor((self.x+16)/32)
		for ii=-1,1 do
			for jj=-1,1 do
				if self.grid[ci+ii][cj+jj] == "1" then
					self.angle = math.atan2((ii),jj)+ math.pi/2
					return
				end
			end
		end
		
		--self.bubble = self.scene:addEntity(SpeechBubble:new(self.x-32, self.y, self.scene))
		--self.bubble:requestFood(2)
		--self.bubble:spawn()
	elseif self.state == LEAVING then
		self:leaveDiner()
	end
end

function Customer:applyForce(x,y)
   if self.timerHandle then
      Timer.cancel(self.timerHandle)
   end
   self.sitting = true
   self.fixture:setSensor(false)
   self.body:applyLinearImpulse(x,y)
end

function Customer:screem()
   local num = love.math.random(1,11)   
   local sound = "screem/screem"..num..".mp3"
   local sndSrc = Resources.static:getSound(sound)
   sndSrc:setVolume(0.5)
   sndSrc:play()

end


function Customer:draw()
   love.graphics.draw(self.img.shadow,self.body:getX(),self.body:getY(),0,1.0,1.0,16,16)
	love.graphics.draw(imgSrc, self.quad, self.body:getX(), self.body:getY(), self.angle,self.scale,self.scale,16,16)
   --love.graphics.circle("fill",self.body:getX(),self.body:getY(),10,10)
end

function Customer:exit()
   self:kill()
end


return Customer
