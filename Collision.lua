local Collision = class("Collision")

function Collision:initialize(scene)
   self.scene = scene

end

function Collision:resolve(a,b,coll)
   local av = a:getUserData()
   local bv = b:getUserData()
   
   if av ~= nil and bv~= nil then
      
      self:handleCollision(av,bv,coll)
      self:handleCollision(bv,av,coll)
   
   else
      print("EEEERRRROOOOORRRRR ;_;")
      print("av",av)
      print("bv",bv)
   end

end


function Collision:handleCollision(a,b,coll)
   local at = a.class.name
   local bt = b.class.name

   if a:isAlive() and b:isAlive() then
      -- BULLET
      if at == "Bullet" then

         if bt == "Bullet" then

         elseif bt == "Table" then
            a:exit()
         elseif bt == "Bound" then
            a:exit()
         elseif bt == "Customer" then
            a:exit()
         end
         -- TABLE
      elseif at == "Table" then
         -- BOUND
      elseif at == "Bound" then
         -- CUSTOMER
      elseif at == "Customer" then
         if bt == "Bullet" then
            a:exit()
         end
      end
   end
end

return Collision

