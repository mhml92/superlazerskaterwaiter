math.random = love.math.random
require 'slam/slam'
class       = require 'middleclass/middleclass'
Sprite		= require 'Sprite'
Scene       = require 'Scene'
Entity      = require 'Entity' 
Resources   = require 'Resources'
vector      = require 'hump/vector-light'
Timer		   = require "hump/timer"

local TitleScene = require "scenes/TitleScene"

SquareSize = 32
--Scenes
local Diner       = require 'scenes/Diner'
local End       = require 'scenes/End'

local time = {}
time.fdt = 1/60 --fixed delta time
time.accum = 0


local self = {}


function love.load()
   love.mouse.setVisible(false)
   local w,h = love.graphics.getDimensions()
   love.graphics.setScissor( 0, 0, w, h)
   Resources.static:loadAll() 
   self.scene = TitleScene:new()   
   self.music = Resources.static:getSound("Hyperfun.mp3")
   self.music:setVolume(0.8)
   self.music:setLooping(true)
   self.music:play()
   self.title = true
   self.endscreen = false

   Resources:loadAll()
end

function love.update(dt)
   time.accum = time.accum + dt 
   while time.accum >= time.fdt do
      self.scene:update(time.fdt)
      time.accum = time.accum - time.fdt
   end
end

function love.draw()
   self.scene:draw()
   --love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10) 
end 

function endGame()
   self.endscreen = true
   self.scene = End:new(self.diner)
end


function love.keypressed( key, isrepeat )
	if key == "escape" then
		if self.title then
         	love.event.quit()
		else
			self.scene = TitleScene:new()
			self.title = true
		end
	elseif self.endscreen and key == " " then
		self.scene = TitleScene:new()
		self.title = true
	end
   self.scene:keypressed(key,isrepeat)
end

function love.keyreleased( key, isrepeat )
   self.scene:keyreleased(key,isrepeat)
end

function love.mousepressed(x,y,button)
	if self.title then
		self.title = false
		self.diner = Diner:new()
		self.scene = self.diner
		return
	end
   self.scene:mousepressed(x,y,button)
end

function love.mousereleased(x,y,button)
   self.scene:mousereleased(x,y,button)
end

function beginContact(a,b,coll)
   self.scene:beginContact(a,b,coll)
end

function endContact(a,b,coll)
   --self.scene:endContact(a,b,coll)
end

function preSolve(a,b,coll)
  -- self.scene:preSolve(a,b,coll)
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
   --self.scene:postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
end
