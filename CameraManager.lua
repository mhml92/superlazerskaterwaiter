local class       = require 'middleclass/middleclass'
local humpCamera  = require 'hump/camera'

local CameraManager = class('CameraManager')

function CameraManager:initialize(scene)
   self.scene = scene
   self.cam = humpCamera(0,0)

   --[[
   -- zoom camera
   --]]
   local zoomFactor = 1
   local w,h = love.graphics.getDimensions()
   local lvlw,lvlh = self.scene.level.width,self.scene.level.height 
   if w > h then
      zoomFactor = h/lvlh
   else
      zoomFactor = w/lvlw
   end

   self.cam:zoomTo(2)
   -- shake vars
   self.rate = 0
   self.shakeStrength = 0
   self.offX = 0
   self.offY = 0
   self.x = nil
   self.y = nil
   -- camera loosness multiplyer
   self.clm = 0.2
end

function CameraManager:update(x,y)
   if self.x == nil then
      self.x,self.y = x,y
   end
   local dx,dy = x-self.x,y-self.y
   self.x,self.y = self.x + (dx*self.clm),self.y + (dy*self.clm)

   if self.shakeStrength > 0.01 then
      local sdir = math.random()*2*math.pi
      self.offX = math.cos(sdir)*self.shakeStrength
      self.offY = math.sin(sdir)*self.shakeStrength
      self.shakeStrength = self.shakeStrength*self.rate
   end

   self.cam:lookAt(self.x + self.offX,self.y + self.offY)
end

function CameraManager:attach()
   self.cam:attach()
end

function CameraManager:detach()
   self.cam:detach()
end

function CameraManager:shake(rate,strength)
   self.rate = math.max(rate,self.rate)
   self.shakeStrength = math.max(strength,self.shakeStrength)
end


return CameraManager
