local End = class("End", Scene)

local imgBg = Resources:getImage("splash.png")

function End:initialize(diner)
	Scene.initialize(self)
   --[[
   -- zoom camera
   --]]
   self.diner = diner
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
	love.graphics.print("Five customers left unsatisfied. That is unacceptable.", 100, 100)
	love.graphics.print("The Skater Waiter initiative has been shut down effective immediately", 100, 120)

   love.graphics.print("You managed to earn "..self.diner.money.." Skater dollars", 100,150)
   love.graphics.print("You played for "..math.floor(self.diner.playTime+0.5).." seconds", 100,170)

   love.graphics.print("Press SPACE to restart Skate Waiter initiative.", 100, 210)
end


function End:keypressed(key, isrepeat)
end

function End:beginContact(a,b,coll)
end

function End:endContact(a,b,coll)
end

function End:preSolve(a,b,coll)
end

function End:postSolve(...)
end


return End
