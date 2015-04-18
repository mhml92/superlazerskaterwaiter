local Resources = class("Resources")

Resources.static.images = {}
Resources.static.sounds = {}

function Resources.static:getImage(filename)
	if self.images[filename] == nil then
		local path = "images/"..filename
		self.images[filename] = lg.newImage(path)
		self.images[filename]:setFilter("nearest", "nearest")
	end
	return self.images[filename]
end

function Resources.static:getSound(filename)
	if self.sounds[filename] == nil then
		local path = "sounds/"..filename
		self.sounds[filename] = love.audio.newSource(path)
	end

	return self.sounds[filename]
end

function Resources.static:loadAll()
end


return Resources
