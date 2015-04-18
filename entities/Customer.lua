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
	Entity.intialize(self, 0, 0, scene)

	self.state = ENTERING
	self.mood = HAPPY
end

function Customer:update(dt)

end

function Customer:draw()

end
