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
   
   end

end


function Collision:handleCollision(a,b,coll)
   local at = a.class.name
   local bt = b.class.name
   -- BULLET
   if at == "Bullet" then

      if bt == "Bullet" then

      elseif bt == "Table" then
         self.scene.gris:addBullet(a,coll)
         a:exit()
      elseif bt == "Bound" then
         self.scene.gris:addBullet(a,coll)
         a:exit()
      elseif bt == "Customer" then
         self.scene.gris:addBullet(a,coll)
         a:exit()
      end
      -- TABLE
   elseif at == "Table" then
      -- BOUND
   elseif at == "Bound" then
      -- CUSTOMER
   elseif at == "Customer" then
      if bt == "Bullet" then
         local dx,dy = b.body:getLinearVelocity()
         local force = 100
         dx,dy = vector.normalize(dx,dy)
         a:applyForce(dx*force,dy*force)
         a:screem()
      elseif bt == "Customer" then

      end
   end
end

return Collision

