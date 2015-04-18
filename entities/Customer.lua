local Customer = class("Customer", Entity)


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

	self.walking = false
	self.waypoints = {}
	self.queue = {}
	self.grid = self.scene.level.matrix
	self.flags = self.scene.level.flagmatrix
	self.w = self.scene.level.numTilesWidth
	self.h = self.scene.level.numTilesHeight
end

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
	if self.walking == false and #self.waypoints > 0 then
		self.walking = true
		local point = table.remove(self.waypoints, 1)
		local tx, ty = 32*point.col, 32*point.row
		Timer.tween(0.5, self, {x = tx, y = ty}, "in-linear",
			function()
				self.walking = false
			end)
	end
end

function Customer:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.x-16, self.y-16, 8)
	love.graphics.setColor(255, 255, 255)
end

return Customer
