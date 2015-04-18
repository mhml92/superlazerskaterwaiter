local Level = class("Level")
local lg = love.graphics
local lp = love.physics

function Level:initialize(x, y,levelName, scene)
   self.floorImg = Resources.static:getImage("floor.png")
   self.tableImg = Resources.static:getImage("table.png")
   self.matrix = {}

   self.width = 0
   self.height = 0
   self.tables = {}
   self.scene = scene
   self.walls = {}
   self.floor = {}
   self.counter = {}
   self.plateDeliveryZone = {}
   self.plateRecieverZoner = {}
   self.counterZone = {}
   self.leftdoor = {}
   self.rightdoor = {}
   self:loadLevelFile(levelName)
end
function Level:loadLevelFile(levelName)
   local path = "levels/"..levelName 
   local x,y = 0,0
   local halfSquare = SquareSize/2

   if love.filesystem.exists(path) then
      for line in love.filesystem.lines(path) do
         dy = y *  SquareSize
         x = 0
         self.matrix[y+1] = {}
         for token in string.gmatch(line, "[^%s]+") do
            dx = x * SquareSize
            self.matrix[y+1][x+1] = token
            if token == "0" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.floor,t)
            end
            
            if token == "1" then
               local t = {}
               t.body = lp.newBody(self.scene.world,dx+halfSquare,dy+halfSquare,"static")
               t.shape = lp.newRectangleShape(SquareSize,SquareSize)
               t.fixture = lp.newFixture(t.body,t.shape)
               table.insert(self.tables,t)
            end

            if token == "2" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.counter,t)
            end

            if token == "3" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.plateDeliveryZone,t)
               
            end

            if token == "4" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.plateRecieverZoner,t)
               
            end

            
            if token == "5" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.counterZone,t)
               
            end

            if token == "6" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.walls,t)
            end
            
            if token == "7" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.leftdoor,t)
               
            end
            if token == "8" then
               local t = {}
               t.x,t.y = dx,dy
               table.insert(self.rightdoor,t)
               
            end
            x = x + 1
         end
         y = y + 1
      end
      self.width = (x) * SquareSize
      self.height = (y) * SquareSize
   else
      print("No such level " .. path)
   end

end


function Level:draw()
   local halfSquare = SquareSize/2
   local lg = love.graphics 
   for i,v in ipairs(self.matrix) do
      for j,w in ipairs(v) do
         local di,dj = i-1,j-1
         lg.draw(self.floorImg,dj*SquareSize,di*SquareSize)
         if w == "1" then
            lg.draw(self.tableImg,dj*SquareSize,di*SquareSize)
         end
      end
   end
   for k,t in ipairs(self.walls) do 
      lg.setColor(0,0,255)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   --[[
   for k,t in ipairs(self.tables) do
      lg.setColor(255,0,0)
      lg.rectangle("fill", t.body:getX()-halfSquare, t.body:getY()-halfSquare, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.floor) do 
      lg.setColor(0,255,0)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.counter) do 
      lg.setColor(127,255,0)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.plateDeliveryZone) do 
      lg.setColor(0,255,127)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.plateRecieverZoner) do 
      lg.setColor(0,127,127)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.counterZone) do 
      lg.setColor(127,127,127)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.leftdoor) do 
      lg.setColor(127,127,0)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   for k,t in ipairs(self.rightdoor) do 
      lg.setColor(127,0,0)
      lg.rectangle("fill", t.x, t.y, SquareSize,SquareSize)
   end
   ]]
   lg.setColor(255,255,255)
end
return Level
