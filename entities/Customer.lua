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

local grid = {}
for i=1,15 do
	grid[i] = {}
	for j=1,18 do
		grid[i][j] = 0
	end
end


function Customer:initialize(x, y, scene)
	Entity.initialize(self, x, y, scene)

	self.state = ENTERING
	self.mood = HAPPY

	self.walking = false
	self.waypoints = {}
	self.queue = {}
	self.grid = self.scene.level.matrix
	self.h = self.scene.level.numtileheight
end

function Customer:navigate(si, sj, ti, tj)
	self.queue = {}
	self:addToQueue(si, sj)
	self:addWaypoint(si, sj)
	while #self.queue > 0 do
		local current = table.remove(self.queue, 1)
		if current.row == ti and current.col == tj then
			self:addWaypoint(ti, tj)
			return
		end
		local bestScore = 100000
		local besti = 0
		local bestj = 0
		for ii=-1,1 do
			for jj=-1,1 do
				local cr, cc = current.row+ii, current.col+jj
				if cr >= 1 and cr <= 15 and cc >= 1 and cc <= 18 then
					if grid[cr][cc] ==  0 then
						if ii~=0 or jj~=0 then
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
		Timer.tween(1, self, {x = tx, y = ty}, "in-linear",
			function()
				self.walking = false
			end)
	end
end

function Customer:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.circle("fill", self.x, self.y, 8)
	love.graphics.setColor(255, 255, 255)
end

return Customer
