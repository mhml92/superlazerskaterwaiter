local PlateGun = class("PlateGun", Entity)
local Bullet = require "Bullet"


function PlateGun:initialize(x, y, parent)
	Entity.initialize(self, 0, 0, parent.scene)
	self.parent = parent
   self.lookDir = 0

end

function PlateGun:shoot()
   self.parent.scene:addEntity(Bullet:new(self.parent))
end

return PlateGun
