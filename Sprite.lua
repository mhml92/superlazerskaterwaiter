local Sprite = class("Sprite")

function Sprite:initialize(parent, filename, sx, sy)
	self.parent = parent
	self.src = love.graphics.newImage(filename)
	self.src:setFilter("nearest", "nearest")
	self.offsetx = sx or 0
	self.offsety = sy or 0
end

function Sprite:update(dt)
end

function Sprite:draw()
	local x, y, r = self.parent:getTranslation()
	love.graphics.draw(self.src, x, y, r, 2, 2, self.offsetx, self.offsety)
end

return Sprite
