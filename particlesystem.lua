require "class"

local G = 6.67408e-11

particle_system = class:new()

function particle_system:init()
	self.particles = {}
end

function particle_system:calculate_acceleration(p)
	local ax, ay = 0, 0
	for i=1, #self.particles do
		local pp = self.particles[i]
		if pp ~= p then
			local dx = p.x - pp.x
			local dy = p.y - pp.y
			local r3 = math.sqrt(dx*dx + dy*dy)^3
			local G_mass_r3 = G * pp.mass / r3
			ax = ax + G_mass_r3 * dx
			ay = ay + G_mass_r3 * dy
		end
	end
	return -ax, -ay
end

function particle_system:update_velocity(p, dt)
	local ax, ay = self:calculate_acceleration(p)
	p.velx = p.velx + ax * dt
	p.vely = p.vely + ay * dt
end

function particle_system:update_position(p, dt)
	p.x = p.x + p.velx * dt
	p.y = p.y + p.vely * dt
end

function particle_system:spawn_particle(x, y, mass, velx, vely, radius, position_ratio, col)
	self.particles[#self.particles + 1] = {
		x = x,
		y = y,
		mass = mass,
		velx = velx,
		vely = vely,
		radius = radius,
		-- ensure that large universe simulations fit into single window
		position_ratio = position_ratio,
		col = col
	}
end

function particle_system:update(dt)
	for i=1, #self.particles do
		self:update_velocity(self.particles[i], dt)
	end
	for i=1, #self.particles do
		self:update_position(self.particles[i], dt)
	end
end

function particle_system:draw_particle(p)
	love.graphics.setColor(p.col.r, p.col.g, p.col.b)
	--print(p.x * p.position_ratio, p.y * p.position_ratio)
	love.graphics.circle("fill", p.x * p.position_ratio, p.y * p.position_ratio, p.radius, 20)
end

function particle_system:draw()
	for i=1, #self.particles do
		self:draw_particle(self.particles[i])
	end
end