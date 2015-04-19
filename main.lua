math.random = love.math.random
require 'slam/slam'
class       = require 'middleclass/middleclass'
Sprite		= require 'Sprite'
Scene       = require 'Scene'
Entity      = require 'Entity' 
Resources   = require 'Resources'
vector      = require 'hump/vector-light'
Timer		   = require "hump/timer"

Collision   = require 'Collision'


SquareSize = 32
--Scenes
local Diner       = require 'scenes/Diner'

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0


local self = {}


function love.load()
   local w,h = love.graphics.getDimensions()
   love.graphics.setScissor( 0, 0, w, h)
   Resources.static:loadAll() 
   self.scene = Diner:new()   
end

function love.update(dt)
   time.accum = time.accum + dt 
   while time.accum >= time.fdt do
      self.scene:update(time.fdt)
      if love.keyboard.isDown('escape') then
         love.event.quit()
      end
      time.accum = time.accum - time.fdt
   end
end

function love.draw()
   self.scene:draw()
   love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) 
end 

function love.keypressed( key, isrepeat )
   self.scene:keypressed(key,isrepeat)
end

function love.keyreleased( key, isrepeat )
   self.scene:keyreleased(key,isrepeat)
end

function love.mousepressed(x,y,button)
   self.scene:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
   self.scene:mousereleased(x,y,button)
end

function beginContact(a,b,coll)
   self.scene:beginContact(a,b,coll)
   local av = a:getUserData()
   local bv = b:getUserData()
   
   if av ~= nil then
      print(av.class.name)
   end
   if bv ~= nil then
      print(bv.class.name)
   end


end

function endContact(a,b,coll)
   self.scene:endContact(a,b,coll)
end

function preSolve(a,b,coll)
   self.scene:preSolve(a,b,coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
   self.scene:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
