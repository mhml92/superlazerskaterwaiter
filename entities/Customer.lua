local Customer = class("Customer", Entity)

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

function Customer:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)

	self.state = ENTERING
	self.mood = HAPPY

	self.walking = true
	self.waypoints = {}
	self.queue = {}
	self.grid = self.scene.level.matrix
	self.flags = self.scene.level.flagmatrix
	self.w = self.scene.level.numTilesWidth
	self.h = self.scene.level.numTilesHeight

	self.quad = quads[8]

	self.lastx = self.x
	self.lasty = self.y
	self.angle = 0

	self.ti = 1
	self.tj = 12
	self.tx = self.tj*32
	self.ty = self.ti*32
	self.x = self.tj*32
	self.y = -100

	self:walk(self.tx, self.ty)
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

--[[
function Customer:navigate(si, sj, ti, tj)
	local grid = self.grid
	local flags = self.flags
	self.queue = {}
	self:addToQueue(si, sj)
	self:addWaypoint(si, sj)
	while #self.queue > 0 do
		local current = table.remove(self.queue, 1)
		if current.row == ti and current.col == tj then
			self:addWaypoint(ti, tj)
			return
		end
		flags[current.row][current.col] = true
		local bestScore = 1000000
		local besti = -1
		local bestj = -1
		for ii=-1,1 do
			for jj=-1,1 do
				if (ii==0 or jj==0) and ii~=jj then
					local cr, cc = current.row+ii, current.col+jj
					if cr >= 1 and cr <= 15 and cc >= 1 and cc <= 18 then
						if grid[cr][cc] == "0" and flags[cr][cc] == false then
							local dist = (ti-cr)^2 + (tj-cc)^2
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
		self:addToQueue(besti, bestj)
		self:addWaypoint(besti, bestj)
	end
end
]]
function Customer:addToQueue(i, j)
	local tmp = {}
	tmp.row = i
	tmp.col = j
	table.insert(self.queue, tmp)
end

function Customer:addWaypoint(i, j)
	local tmp = {}
	tmp.row = i
	tmp.col = j
	table.insert(self.waypoints, tmp)
end

function Customer:update(dt)
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
							if self.grid[cr][cc] == "0" then
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
		end
	end
end

function Customer:draw()
	love.graphics.draw(imgSrc, self.quad, self.x-32, self.y-32, self.angle)
end

return Customer
