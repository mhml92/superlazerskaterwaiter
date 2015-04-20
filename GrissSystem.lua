local GrissSystem = class("GrissSystem")
local BrokenPlate = require "entities/BrokenPlate"


function GrissSystem:initialize(scene)
   self.scene = scene
   self.brokenBullets = {}

   self.plates = {}


end

function GrissSystem:addBullet(b,coll)
   local bx,by = b.x,b.y
   local vx,vy = b.lvx,b.lvy
   for i = 1,3 do
      table.insert(self.plates,BrokenPlate:new(i,bx,by,vx,vy,self.scene))
   end


   
end

function GrissSystem:update(dt)
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


end

function GrissSystem:draw()
   for k,v in ipairs(self.plates) do
      v:draw()
   end

end



return GrissSystem
