local Customer = class("Customer", Entity)

local SpeechBubble = require "SpeechBubble"

local imgSrc = Resources.static:getImage("persons.png")
local quads = {}
for i=0,8 do
	quads[i] = love.graphics.newQuad(i*32, 0, 32, 32, 288, 32)
end

local ENTERING = 0
local ORDERING = 1
local EATING = 3
local LEAVING = 4
local TOTOILET = 5
local TOILET = 6
local FROMTOILET = 7

local HAPPY = 0
local ANGRY = 1

function Customer:initialize(x, y, scene, person)
	Entity.initialize(self, x, y, scene)


   self.width = 20
   self.height = 20
   self.radius = 10
	self.state = ENTERING
	self.mood = HAPPY

	self.walking = true
	self.grid = self.scene.level.matrix
	self.w = self.scene.level.numTilesWidth
	self.h = self.scene.level.numTilesHeight

	self.quad = quads[person]

	self.lastx = self.x
	self.lasty = self.y
	self.angle = 0

   local phys = love.physics
	self.body = phys.newBody(self.scene.world, x+(self.width/2), y+(self.height/2), "kinematic")
	self.shape = phys.newCircleShape(self.radius)
	self.fixture = phys.newFixture(self.body, self.shape)
   self.fixture:setUserData(self)
   self.fixture:setSensor(true)


	self.ti = 1
	self.tj = 12
	self.tx = self.tj*32
	self.ty = self.ti*32
	self.x = self.tj*32
	self.y = -100

	self:walk(self.tx, self.ty)

	self.sitting = false

	self.bubble = nil
end

function Customer:navigate(i, j)
	self.ti = i
	self.tj = j
end

function Customer:walk(tx, ty)
	self.tx = tx
	self.ty = ty
	self.walking = true
	Timer.tween(0.5, self, {x=tx, y=ty}, "in-linear", function()
			self.walking = false
		end
		)
end

function Customer:update(dt)
	if self.sitting then return end
	if self.walking == false then
		local ci, cj = math.floor((self.y+16)/32), math.floor((self.x+16)/32)
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
							if token == "0" or token == "16" then
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
			self:walk(32*bestj, 32*besti)
		else
			self:arrived()
		end
	end
   self.body:setX(self.x-32)
   self.body:setY(self.y-32)
end

function Customer:arrived()
	self.sitting = true
	self.bubble = self.scene:addEntity(SpeechBubble:new(self.x-32, self.y, self.scene))
	self.bubble:requestFood(2)
	self.bubble:spawn()
end

function Customer:draw()
	love.graphics.draw(imgSrc, self.quad, self.x-32, self.y-32, self.angle)
end

function Customer:exit()
   self:kill()
end


return Customer
