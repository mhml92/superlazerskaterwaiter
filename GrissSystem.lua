local GrissSystem = class("GrissSystem")
local BrokenPlate = require "entities/BrokenPlate"


local wallgriss = Resources.static:getImage("griss_sheet.png")
local wallQuad = {}
for i=1,7 do
	wallQuad[i] = love.graphics.newQuad((i-1)*32, 0, 32, 32, 224, 32)
end


function GrissSystem:initialize(scene)
   self.scene = scene
   self.brokenBullets = {}

   self.plates = {}
   self.walls = {}

end

function GrissSystem:addWall(wall,bullet,coll)
   local tmp = {}
   local lvl = self.scene.level  
   local halfSquare = SquareSize/2
   local t,r,b,l = halfSquare,lvl.width-halfSquare,lvl.height-halfSquare,halfSquare

   if bullet.x < lvl.width/2 then
      
      if math.abs(bullet.x-l) < math.min(math.abs(bullet.y-t),math.abs(bullet.y-b)) then
         tmp.o = -math.pi/2
         tmp.y = bullet.y
         tmp.x = l
      elseif bullet.y < lvl.height/2 then
         tmp.y = t
         tmp.x = bullet.x
      else
         tmp.o = -math.pi
         tmp.y = b
         tmp.x = bullet.x
      end
   else
      if math.abs(bullet.x-r) < math.min(math.abs(bullet.y-t),math.abs(bullet.y-b)) then
         tmp.o = math.pi/2
         tmp.y = bullet.y
         tmp.x = r
      elseif bullet.y < lvl.height/2 then
         tmp.y = t
         tmp.x = bullet.x
      else
         tmp.o = -math.pi
         tmp.y = b
         tmp.x = bullet.x
      end
   end

   

   tmp.q = wallQuad[love.math.random(1,7)] 

   if orientation == "top" then
      tmp.r = 0
   elseif orientation == "bottom" then
      tmp.r = 0
   elseif orientation == "left" then
      tmp.r = 0
   elseif orientation == "right" then
      tmp.r = 0
   end
   table.insert(self.walls,tmp)
end



function GrissSystem:addBullet(b,coll)
   local bx,by = b.x,b.y
   local vx,vy = b.lvx,b.lvy
   for i = 1,3 do
      table.insert(self.plates,BrokenPlate:new(i,bx,by,vx,vy,self.scene))
   end


   
end

function GrissSystem:update(dt)
   
   -- PLATES
   
   for i = #self.plates,1,-1 do
      local v = self.plates[i]
      v:update(dt)
      local dx,dy = v.body:getPosition()
      local lvl = self.scene.level
      if dx > lvl.width-SquareSize or dx < 0+SquareSize then
         v.body:destroy()
         table.remove(self.plates,i) 
      elseif dy > lvl.height - SquareSize or dy < 0+SquareSize then
         v.body:destroy()
         table.remove(self.plates,i) 
      end


   end
   while #self.plates > 500 do
      table.remove(self.plates,1)
   end


   -- WALLS

end



function GrissSystem:draw()
   for k,v in ipairs(self.walls) do
	   love.graphics.draw(wallgriss, v.q, v.x, v.y, v.o, 1, 1, 16, 16)
   end
   for k,v in ipairs(self.plates) do
      v:draw()
   end

end



return GrissSystem
