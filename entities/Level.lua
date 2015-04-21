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
   self.img.bg       = Resources.static:getImage("background.png")
   
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

   self.doori = 1
   self.doorj = 1
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
   self:setLinks()
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
               table.insert(self.tables,Table:new(dx+halfSquare,dy+halfSquare,self.scene, y+1, x+1))
            end
            if token == "16" then
               table.insert(self.chairs,Chair:new(dx+halfSquare,dy+halfSquare,self.scene, y+1, x+1))
            end
			if token == "7" then
				self.doori = y+1
				self.doorj = x+1
			end
            
            x = x + 1
         end
         y = y + 1
      end
      self.numTilesWidth = x
      self.numTilesHeight = y
      self.width = (x) * SquareSize
      self.height = (y) * SquareSize
     
      local thickness = 500
      table.insert(self.bounds,Bound:new(0,SquareSize-thickness,self.width,thickness,self.scene))
      table.insert(self.bounds,Bound:new(SquareSize-thickness,0,thickness,self.height,self.scene))
      
      table.insert(self.bounds,Bound:new(0,self.height-SquareSize,self.width,thickness,self.scene))
      table.insert(self.bounds,Bound:new(self.width-SquareSize,0,thickness,self.height,self.scene))
      --table.insert(self.bounds,Bound:new(0,self.height-SquareSize,self.width-(2*SquareSize),100,self.scene))
      --table.insert(self.bounds,Bound:new(self.width-SquareSize,SquareSize,1,self.height-(2*SquareSize),self.scene))

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
--[[
   for i,v in ipairs(self.matrix) do
      for j,w in ipairs(v) do
         local di,dj = i-1,j-1
         lg.draw(img.floor,dj*SquareSize,di*SquareSize)
      end
   end
   for i,v in ipairs(self.matrix) do
      for j,w in ipairs(v) do
         local di,dj = i-1,j-1
         
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
   ]]
   lg.draw(img.bg)
   for k,v in ipairs(self.tables) do
      v:draw()
   end
   for k,v in ipairs(self.chairs) do
      v:draw()
   end
   --[[
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

function Level:setLinks()
	for i = 1,#self.tables do
		local table = self.tables[i]
		for j=1, #self.chairs do
			local chair = self.chairs[j]
			if (math.abs(table.i-chair.i) < 1.5 and math.abs(table.j-chair.j) < 1.5) 
			and (table.i == chair.i or table.j == chair.j)then
				chair.table = table
				table.chair = chair
				break
			end
		end
		print("OH SHIT")
	end
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
