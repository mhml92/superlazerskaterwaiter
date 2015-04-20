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
   print(vx,vy)
   for i = 1,3 do
      table.insert(self.plates,BrokenPlate:new(i,bx,by,vx,vy,self.scene))
   end


   
end

function GrissSystem:update(dt)
   for k,v in ipairs(self.plates) do
      v:update(dt)
   end

end

function GrissSystem:draw()
   for k,v in ipairs(self.plates) do
      v:draw()
   end

end



return GrissSystem
