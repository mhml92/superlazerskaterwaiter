local TitleScene = class("TitleScene", Scene)

local imgBg = Resources:getImage("splash.png")

function TitleScene:initialize()
	Scene.initialize(self)
   --[[
   -- zoom camera
   --]]
   self.zoomFactor = 1
   local w,h = love.graphics.getDimensions()
   local lvlw,lvlh = 320,240 
   if w > h then
      self.zoomFactor = h/lvlh
   else
      self.zoomFactor = w/lvlw
   end
   self.x,self.y = love.graphics.getDimensions()
   self.x = self.x/2
   self.y = self.y/2
end

function TitleScene:draw()
	love.graphics.draw(imgBg, self.x, self.y, 0,self.zoomFactor,self.zoomFactor,160,120)
end

return TitleScene
