local Resources = class("Resources")

Resources.static.images = {}
Resources.static.sounds = {}

function Resources.static:getImage(filename)
	if self.images[filename] == nil then
		local path = filename
		self.images[filename] = love.graphics.newImage(path)
		self.images[filename]:setFilter("nearest", "nearest")
	end
	return self.images[filename]
end

function Resources.static:getSound(filename)
	if self.sounds[filename] == nil then
		local path = "sound/"..filename
		self.sounds[filename] = love.audio.newSource(path)
	end

	return self.sounds[filename]
end

function Resources.static:loadAll()
   self:getSound("plates/plates1.mp3")   
   self:getSound("plates/plates2.mp3")   
   self:getSound("plates/plates3.mp3")   
   self:getSound("plates/plates4.mp3")   
   self:getSound("plates/plates5.mp3")   
   self:getSound("plategun/slurp.mp3")   
   self:getSound("plategun/pop.mp3")   
   self:getSound("screem/screem1.mp3")   
   self:getSound("screem/screem2.mp3")   
   self:getSound("screem/screem3.mp3")   
   self:getSound("screem/screem4.mp3")   
   self:getSound("screem/screem5.mp3")   
   self:getSound("screem/screem6.mp3")   
   self:getSound("screem/screem7.mp3")   
   self:getSound("screem/screem8.mp3")   
   self:getSound("screem/screem9.mp3")   
   self:getSound("screem/screem10.mp3")   
   self:getSound("screem/screem11.mp3")   
end


return Resources
