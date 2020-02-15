require "camera"
require "particlesystem"

local camera = camera:new()
local universe = nil

-- VERY SENSITIVE TO COMPUTATIONS, DON'T OVERDO IT!!!
local delta_time_ratio = 20
local time_ratio = delta_time_ratio * 180 * 24

local function setup_solar_system()
	-- Convert every object from solar system to our window
	local position_ratio = camera.virt_h * 0.45 / 4.5e12
	
	universe = particle_system:new()
	-- FYI: Planet radiuses and their orbit diameters are just imaginary!
	
	-- SUN
	universe:spawn_particle(0, 0, 2e30, 0, 0, 15, 0, { r=1, g=1, b=0 })
	-- MERCURY
	universe:spawn_particle(0, 5.7e10, 3.285e23, 47000, 0, 3, position_ratio * 8.5, { r=173/255, g=168/255, b=165/255 })
	-- VENUS
	universe:spawn_particle(0, 1.1e11, 4.8e24, 35000, 0, 5, position_ratio * 6, { r=139/255, g=69/255, b=19/255 })
	-- EARTH
	universe:spawn_particle(0, 1.5e11, 6e24, 30000, 0, 5, position_ratio * 6.5, { r=0, g=0.3, b=1 })
	-- MARS
	universe:spawn_particle(0, 2.2e11, 2.4e24, 24000, 0, 4, position_ratio * 6, { r=231/255, g=125/255, b=17/255 })
	-- JUPITER
	universe:spawn_particle(0, 7.7e11, 1e28, 13000, 0, 10, position_ratio * 2.8, { r=216/255, g=202/255, b=157/255 })
	-- SATURN
	universe:spawn_particle(0, 1.4e12, 5.7e26, 9000, 0, 9, position_ratio * 2.1, { r=123/255, g=120/255, b=105/255 })
	-- URANUS
	universe:spawn_particle(0, 2.8e12, 8.7e25, 6835, 0, 8, position_ratio * 1.4, { r=213/255, g=251/255, b=252/255 })
	-- NEPTUNE
	universe:spawn_particle(0, 4.5e12, 1e26, 5477, 0, 8, position_ratio, { r=39/255, g=70/255, b=135/255 })
end

function love.wheelmoved(x, y)
	camera:zoom(y)
end

function love.keypressed(key)
	if key == 'q' then
		time_ratio = math.min(time_ratio * 2, delta_time_ratio * 180 * 24 * 5)
	elseif key == 'w' then
		time_ratio = math.max(time_ratio / 2, delta_time_ratio * 180 * 24)
	end
end

function love.load()
	love.window.setTitle("N-Body Simulation")
	love.window.setMode(camera.real_w, camera.real_h, {msaa = 4})
	setup_solar_system()
end

function love.update(dt)
	camera:update()
	
	-- For sake of precision of calculations, divide update into smaller steps.
	-- It's bad idea to simulate e.g. one year in single calculation step
	for x=1,time_ratio/delta_time_ratio do
		universe:update(dt * delta_time_ratio)
	end
end

function love.draw()
	love.graphics.push()
	camera:use()
	universe:draw()
	love.graphics.pop()
	camera:draw_info()
	love.graphics.print("Time ratio: " .. time_ratio .. "x sec", 10, 46)
end