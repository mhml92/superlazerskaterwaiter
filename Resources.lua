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
end


return Resources
