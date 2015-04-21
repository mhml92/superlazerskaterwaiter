local End = class("End", Scene)

local imgBg = Resources:getImage("splash.png")

function End:initialize()
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

function End:draw()
	love.graphics.draw(imgBg, self.x, self.y, 0,self.zoomFactor,self.zoomFactor,160,120)
   love.graphics.print("Money:", 100,100)
end

return End
