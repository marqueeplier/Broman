function main_menu()
	love.filesystem.setIdentity("Broman remaster", false)

	screenWidth = love.graphics.getWidth()
	screenHeight = love.graphics.getHeight()

	title_img = love.graphics.newImage("assets/mainmenu/title.png")

	buttons_menu = {
					start = {x = 275, y = 170, width = 250, height = 50, 
							 img = love.graphics.newImage("assets/mainmenu/start.png")},
					highscore = {x = 275, y = 270, width = 250, height = 50,
							 img = love.graphics.newImage("assets/mainmenu/highscore.png")},
					settings = {x = 275, y = 370, width = 250, height = 50,
							 img = love.graphics.newImage("assets/mainmenu/settings.png")},
					quit = {x = 275, y = 470, width = 250, height = 50,
					         img = love.graphics.newImage("assets/mainmenu/quit.png")}	
					}
	
	_start = buttons_menu.start
	_highscore = buttons_menu.highscore
	_settings = buttons_menu.settings
	_quit = buttons_menu.quit

	mousebox = {x = 0, y = 0, width = 10, height = 10}

	states = {
			  menu = "menu", 
			  action = "action", 
			  settings = "settings"
			 }

	current_state = states.menu
end

function menu_update(dt)
	if CheckCollisions(mousebox, _start) then
		current_state = states.action	
		mousebox.x = 0 
		mousebox.y = 0
	end

	if CheckCollisions(mousebox, _highscore) then
		mousebox.x = 0 
		mousebox.y = 0
	end
	
	if CheckCollisions(mousebox, _settings) then
		current_state = states.settings
		mousebox.x = 0 
		mousebox.y = 0
	end

	if CheckCollisions(mousebox, _quit) then
		love.quit()
	end
end

function menu_mouse(x, y, b, istouch)
	if current_state == states.menu or current_state == states.settings then
		mousebox.x = x
		mousebox.y = y
	end
end

function menu_draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(title_img, 225, 40)

	for i, b in pairs(buttons_menu) do 
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(b.img, b.x, b.y)
	end
	
	love.graphics.setFont(myfont)
	love.graphics.setColor(25, 25, 25)
	love.graphics.print(player.highscore, _highscore.x + 210, _highscore.y + 10)

	love.graphics.setColor(255, 255, 255, 1)
	love.graphics.rectangle("fill", mousebox.x, mousebox.y, mousebox.width, mousebox.height)		
end

function settings_load()
	buttons_settings = {
						music = {x = 250, y = 150, width = 250, height = 50, toggle = "Off",
								text = "Music: "},
						gfx = {x = 250, y = 250, width = 250, height = 50, toggle = "Bad",
								text = "Gfx: "},
						fullscreen = {x = 250, y = 350, width = 250, height = 50, toggle = "No",
								text = "fullscreen: "}
						}

	_music = buttons_settings.music
	_gfx = buttons_settings.gfx
	_fullscreen = buttons_settings.fullscreen

	playing = false
	gudgfx = false
end

function settings_update(dt)
	if CheckCollisions(mousebox, _music) and _music.toggle == "Off" then	
		music_on()
	end

	if CheckCollisions(mousebox, _music) and _music.toggle == "On" then	
		music_off()
	end

	if CheckCollisions(mousebox, _gfx) and _gfx.toggle == "Bad" then	
		gfx_on()
	end

	if CheckCollisions(mousebox, _gfx) and _gfx.toggle == "Gud" then	
		gfx_off()
	end

	if CheckCollisions(mousebox, _fullscreen) and _fullscreen.toggle == "No" then	
		fullscreen_on()
	end

	if CheckCollisions(mousebox, _fullscreen) and _fullscreen.toggle == "Yes" then	
		fullscreen_off()
	end

	if playing == true then
		sounds.background:setLooping(sounds.background)
		love.audio.play(sounds.background)
	elseif playing == false then
		love.audio.stop(sounds.background)
	end
end

function settings_draw()
	for i, b in pairs(buttons_settings) do 
		love.graphics.setColor(120, 50, 100)
		love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
		love.graphics.setColor(23, 23, 23)
		love.graphics.setFont(myfont)
		love.graphics.print(b.text..b.toggle, b.x + 15, b.y + 15)
	end

	love.graphics.print("'M' to go back to menu", _fullscreen.x + 15, _fullscreen.y + 100)
end

backgrounds = {}

function backgrounds:load()
	self.images = {
				   grass = love.graphics.newImage("assets/backgrounds/grass.png"),
				   sand = love.graphics.newImage("assets/backgrounds/sand.png"),
				   cobble =	love.graphics.newImage("assets/backgrounds/cobble.png"),
				   mud =	love.graphics.newImage("assets/backgrounds/mud.png")
				   }

	self.current_background = self.images.grass
	self.counter = 0
end

function backgrounds:update(dt)
	if self.counter <= 25 then
		self.current_background = self.images.sand
	end 

	if self.counter >= 25 and self.counter <= 50 then
		self.current_background = self.images.grass
	end 
	
	if self.counter >= 50 and self.counter <= 75 then
		self.current_background = self.images.cobble
	end 

	if self.counter >= 75 and self.counter < 100 then
		self.current_background = self.images.mud
	end 

	if self.counter == 100 then
		self.counter = 0
	end
end

function backgrounds:draw()
	love.graphics.setColor(255, 255, 255)
	if gudgfx == true then
		love.graphics.push()
		love.graphics.scale(5)
		for x = 0, love.graphics.getWidth(), self.current_background:getWidth() do
			for y = 0, love.graphics.getHeight(), self.current_background:getHeight() do
				love.graphics.draw(self.current_background, x, y)
			end
		end
		love.graphics.pop()
	end
end 

function datastore_load()
	highscores = {}

	if not love.filesystem.exists("scores.lua") then
		scores = love.filesystem.newFile("scores.lua")
	end
	
	for lines in love.filesystem.lines("scores.lua") do
		table.insert(highscores, lines)
	end

	player.highscore = highscores[3]
end

function datastore_update(dt)
	if player.score > tonumber(player.highscore) then
		player.highscore = player.score
		love.filesystem.write("scores.lua", "player.highscore\n=\n"..player.highscore)
	end
end

function love.quit()
	love.filesystem.write("scores.lua", "player.highscore\n=\n"..player.highscore)
	love.event.quit()
end

--settings functions 

function music_on()
	mousebox.x = 0 
	mousebox.y = 0
	playing = true
	_music.toggle = "On"
end

function music_off()
	mousebox.x = 0 
	mousebox.y = 0
	playing = false
	_music.toggle = "Off"
end

function gfx_on()
	mousebox.x = 0 
	mousebox.y = 0
	gudgfx = true
	_gfx.toggle = "Gud"
end

function gfx_off()
	mousebox.x = 0 
	mousebox.y = 0
	gudgfx = false
	_gfx.toggle = "Bad"
end

function fullscreen_on()
	mousebox.x = 0 
	mousebox.y = 0
	_fullscreen.toggle = "Yes"
	love.window.setFullscreen(true, "normal")
end

function fullscreen_off()
	mousebox.x = 0 
	mousebox.y = 0
	_fullscreen.toggle = "No"
	love.window.setFullscreen(false, "normal")
end