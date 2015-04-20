local TitleScene = class("TitleScene", Scene)

local imgBg = Resources:getImage("splash.png")

function TitleScene:initialize()
	Scene.initialize(self)
end

function TitleScene:draw()
	love.graphics.draw(imgBg, 0, 0, 0, 4, 4)
end

return TitleScene