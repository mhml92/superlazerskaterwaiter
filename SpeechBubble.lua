local Info = require "Info"

local SpeechBubble = class("SpeechBubble", Info)

local imgSrc = Resources.static:getImage("speech_bubble.png")

local foodSrc = Resources.static:getImage("dinner_plates.png")
local foodQuad = {}
for i=1,3 do 
	foodQuad[i] = love.graphics.newQuad((i-1)*16, 0, 16, 16, 48, 16)
end

function SpeechBubble:initialize(x, y, scene)
	Info.initialize(self, x, y, scene)
end

function SpeechBubble:requestFood(kind)
	self.food = kind
end

function SpeechBubble:update(dt)

end

function SpeechBubble:draw()
	local s = self.scale
	love.graphics.draw(imgSrc, self.x, self.y, 0, s, s)
	if self.food then
		love.graphics.draw(foodSrc, foodQuad[self.food], self.x+8, self.y+10, 0, s, s)
	end
end

return SpeechBubble
