require "class"

camera = class:new()

function camera:init()
	self.virt_w = 1920 -- virtual width
	self.virt_h = 1080 -- virtual height
	self.real_w = 960 -- real window width
	self.real_h = 540 -- real window height
	self.cx = 0 -- center x
	self.cy = 0 -- center y
	self.z = 1.0 -- zoom
	
	self.mouse_x = nil
	self.mouse_y = nil
end

function camera:move(dx, dy)
	self.cx = self.cx + dx
	self.cy = self.cy + dy
end

function camera:transform_coords(x, y)
	local sx, sy = self:get_scale()
	return x / sx, y / sy
end

function camera:zoom(z)
	self.z = math.min(10, math.max(0.2, self.z + z * 0.1))
end

function camera:get_scale()
	return self.real_w / self:get_virt_w(), self.real_h / self:get_virt_h()
end

function camera:get_pos()
	return self.cx + self:get_virt_w() / 2, self.cy + self:get_virt_h() / 2
end

function camera:get_virt_w()
	return self.virt_w / self.z
end

function camera:get_virt_h()
	return self.virt_h / self.z
end

function camera:use()
	local sx, sy = self:get_scale()
	local px, py = self:get_pos()
	love.graphics.scale(sx, sy)
	love.graphics.translate(px, py)
end

function camera:update()
	if love.mouse.isDown(1) then
		local mx, my = love.mouse.getPosition()
		mx, my = self:transform_coords(mx, my)
		if self.mouse_x and self.mouse_y then
			self:move(mx - self.mouse_x, my - self.mouse_y)
		end
		self.mouse_x = mx
		self.mouse_y = my
	else
		self.mouse_x = nil
		self.mouse_y = nil
	end
end

function camera:draw_info()
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("Cam X: " .. self.cx, 10, 10)
	love.graphics.print("Cam Y: " .. self.cy, 10, 22)
	love.graphics.print("Cam ZOOM: " .. self.z, 10, 34)
end