local Level = class("Level")
local Bound = require 'Floor' 
local lg = love.graphics
local lp = love.physics

local Table = require "entities/Table"
local Chair = require "entities/Chair"

function Level:initialize(x, y,levelName, scene)
   self.img = {}
   self.img.floor = Resources.static:getImage("floor.png")
   --self.img.table = Resources.static:getImage("table.png")
   
   self.img.tlc   = Resources.static:getImage("tlc.png")
   self.img.trc   = Resources.static:getImage("trc.png")
   self.img.blc   = Resources.static:getImage("blc.png")
   self.img.brc   = Resources.static:getImage("brc.png")
   
   self.img.tw    = Resources.static:getImage("tw.png")
   self.img.rw    = Resources.static:getImage("rw.png")
   self.img.bw    = Resources.static:getImage("bw.png")
   self.img.lw    = Resources.static:getImage("lw.png")
   self.img.shadow    = Resources.static:getImage("shadow.png")

   self.img.chair    = Resources.static:getImage("chair.png")
   
   self.img.prz1    = Resources.static:getImage("prz1.png")
   self.img.prz2    = Resources.static:getImage("prz2.png")
   self.img.prz3    = Resources.static:getImage("prz3.png")

   self.matrix = {}

   self.width = 0
   self.height = 0
   self.numTilesWidth = 0
   self.numTilesHeight = 0
   self.scene = scene
   self.tables = {}
   self.bounds = {}
   self.chairs = {}
   --[[
   self.walls = {}
   self.floor = {}
   self.counter = {}
   self.plateDeliveryZone = {}
   self.plateRecieverZoner = {}
   self.counterZone = {}
   self.leftdoor = {}
   self.rightdoor = {}
   ]]
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
            
            if token == "1" then
               table.insert(self.tables,Table:new(dx+halfSquare,dy+halfSquare,self.scene))
            end
            if token == "16" then
               table.insert(self.chairs,Chair:new(dx+halfSquare,dy+halfSquare,self.scene, y+1, x+1))
            end
            
            x = x + 1
         end
         y = y + 1
      end
      self.numTilesWidth = x
      self.numTilesHeight = y
      self.width = (x) * SquareSize
      self.height = (y) * SquareSize
      
      table.insert(self.bounds,Bound:new(SquareSize,SquareSize,self.width-(2*SquareSize),1,self.scene))
      table.insert(self.bounds,Bound:new(SquareSize,SquareSize,1,self.height-(2*SquareSize),self.scene))
      
      table.insert(self.bounds,Bound:new(SquareSize,self.height-SquareSize,self.width-(2*SquareSize),1,self.scene))
      table.insert(self.bounds,Bound:new(self.width-SquareSize,SquareSize,1,self.height-(2*SquareSize),self.scene))

   else
      print("No such level " .. path)
   end
   
   

end


function Level:update(dt)
   for k,v in ipairs(self.tables) do
      v:update(dt)
   end

end


function Level:draw()
   local halfSquare = SquareSize/2
   local lg = love.graphics 
   
   local img = self.img

   for i,v in ipairs(self.matrix) do
      for j,w in ipairs(v) do
         local di,dj = i-1,j-1
         lg.draw(img.floor,dj*SquareSize,di*SquareSize)
      end
   end
   for i,v in ipairs(self.matrix) do
      for j,w in ipairs(v) do
         local di,dj = i-1,j-1
         --[[
         if w == "1" then
            lg.draw(img.shadow,dj*SquareSize+16,di*SquareSize+16,0,1.3,1.3,16,16)
            lg.draw(img.table,dj*SquareSize,di*SquareSize)
         end
         ]]
         
         if w == "6" then
            lg.draw(img.tw,dj*SquareSize,di*SquareSize)
         end
         if w == "13" then
            lg.draw(img.rw,dj*SquareSize,di*SquareSize)
         end
         if w == "14" then
            lg.draw(img.bw,dj*SquareSize,di*SquareSize)
         end
         if w == "15" then
            lg.draw(img.lw,dj*SquareSize,di*SquareSize)
         end
         
         if w == "9" then
            lg.draw(img.tlc,dj*SquareSize,di*SquareSize)
         end
         if w == "10" then
            lg.draw(img.trc,dj*SquareSize,di*SquareSize)
         end
         if w == "11" then
            lg.draw(img.blc,dj*SquareSize,di*SquareSize)
         end
         if w == "12" then
            lg.draw(img.brc,dj*SquareSize,di*SquareSize)
         end
         --[[
         if w == "16" then
            lg.draw(img.shadow,dj*SquareSize+16,di*SquareSize+16,0,1.2,1.2,16,16)
            lg.draw(img.chair,dj*SquareSize,di*SquareSize)
         end
         ]]
         
         if w == "41" then
            lg.draw(img.prz1,dj*SquareSize,di*SquareSize)
         end
         if w == "42" then
            lg.draw(img.prz2,dj*SquareSize,di*SquareSize)
         end
         if w == "43" then
            lg.draw(img.prz3,dj*SquareSize,di*SquareSize)
         end
      end
   end
   
   for k,v in ipairs(self.tables) do
      v:draw()
   end
   for k,v in ipairs(self.chairs) do
      v:draw()
   end

   --[[
   --DEBUG 
   for k,v in ipairs(self.bounds) do
      v:draw()
   end
     ]]
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

function Level:getEmptyTile()
	local i = 1
	local j = 1
	while self.matrix[i][j] ~= "0" do
		i = love.math.random(1, self.numTilesHeight)
		j = love.math.random(1, self.numTilesWidth)
	end
	return i, j
end

return Level
