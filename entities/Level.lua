local Level = class("Level", Entity)
local lg = love.graphics
local lp = love.physics

function Level:initialize(x, y,levelName, scene)
	Entity.initialize(self, x, y, scene)
   self.tables = {}
   self.walls = {}
   self.floor = {}
   self.counter = {}
   self.plateDeliveryZone = {}
   self.plateRecieverZoner = {}

   self:loadLevelFile(levelName)

   --[[self.body      = lp.newBody(self.scene.world, x, y, "dynamic")
	self.shape     = lp.newCircleShape(self.radius)
	self.fixture   = lp.newFixture(self.body, self.shape)
	self.fixture:setRestitution(self.restitution)
   self.body:setLinearDamping(self.linearDamping)
    ]]

end

function Level:update(dt)

end

function Level:loadLevelFile(levelName)
   local path = "levels/"..levelName 
   local x,y = 0,0
   local halfSquare = SquareSize/2
   if love.filesystem.exists(path) then
      for line in love.filesystem.lines(path) do
         print("line")
         dy = y *  SquareSize
         x = 0
         for token in string.gmatch(line, "[^%s]+") do
            dx = x * SquareSize
            
            if token == "1" then
               local t = {}
               t.body = lp.newBody(self.scene.world,dx+halfSquare,dy+halfSquare,"static")
               t.shape = lp.newRectangleShape(SquareSize,SquareSize)
               t.fixture = lp.newFixture(t.body,t.shape)
               table.insert(self.tables,t)
            end

            if token == "6" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.walls,t)
            end
            x = x + 1
         end
         y = y + 1
      end
   else
      print("No such level " .. path)
   end

end


function Level:draw()
   local halfSquare = SquareSize/2
   for k,t in ipairs(self.walls) do 
      lg.setColor(0,0,255)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end

   for k,t in ipairs(self.tables) do
      lg.setColor(255,0,0)
      lg.rectangle("fill", t.body:getX()-halfSquare, t.body:getY()-halfSquare, SquareSize,SquareSize)
   end

   lg.setColor(255,255,255)
end

function Level:mousepressed(x, y, button)
   self.isApplyingForce = true
end

function Level:mousereleased(x, y, button)
   self.isApplyingForce = false
end

function Level:applyForce(x,y)
   self.body:applyForce(x,y)
end


return Level
