require "player"
require "mainmenu"
require "enemy"
require "collisions"

function love.load()
	sounds = {
			  gunshot = love.audio.newSource("assets/sounds and others/gunsound.wav"),
			  reload = love.audio.newSource("assets/sounds and others/reload.wav"),
			  blank = love.audio.newSource("assets/sounds and others/blank.wav"),
			  zombiespawn = love.audio.newSource("assets/sounds and others/zombiespawn.wav"),
			  zombiedeath = love.audio.newSource("assets/sounds and others/zombiedeath.wav"),
			  iamdead = love.audio.newSource("assets/sounds and others/iamdead.wav"),
			  background = love.audio.newSource("assets/sounds and others/music.wav", "stream"),
			  hurt = love.audio.newSource("assets/sounds and others/hurt.wav")
			  }

	myfont = love.graphics.newFont("assets/sounds and others/ka1.ttf")
	
	datastore_load()
	main_menu()
	settings_load()
	player:load()
	enemy:load()
	backgrounds:load()
end

function love.update(dt)
	if current_state == states.menu then
		menu_update(dt)
	end

	if current_state == states.action then
		backgrounds:update(dt)
		player:update(dt)
		enemy:update(dt)
	end

	if current_state == states.settings then
		settings_update(dt)
	end

	datastore_update(dt)
end

function love.draw()

	if current_state == states.menu then
		menu_draw()
	end

	if current_state == states.action then
		backgrounds:draw()
		player:draw()
		enemy:draw()
	end

	if current_state == states.settings then
		settings_draw()
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.quit()
	elseif key == "m" then
		current_state = states.menu
		mousebox.x = 0
		mousebox.y = 0
	end
end

function love.mousepressed(x, y, b, istouch)
	menu_mouse(x, y, b, istouch)
end