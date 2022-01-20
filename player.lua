player = {}

function player:load()
	love.graphics.setBackgroundColor(225, 105, 105)
	love.graphics.setDefaultFilter("nearest", "nearest")
	self.x = 65 
	self.y = 45
	self.width = 16
	self.height = 16
	self.speed = 800
	self.health = 100
	self.states = {left = "left", right = "right", up = "up", down = "down"}
	self.current_state = self.states.up
	self.bullets = {}

	self.images = {
				   left_img = love.graphics.newImage("assets/player/left.png"),
				   right_img = love.graphics.newImage("assets/player/right.png"),
				   up_img = love.graphics.newImage("assets/player/up.png"),
				   down_img = love.graphics.newImage("assets/player/down.png"),
				   leftshoot_img = love.graphics.newImage("assets/player/shootleft.png"),
				   rightshoot_img = love.graphics.newImage("assets/player/shootright.png"),
				   upshoot_img = love.graphics.newImage("assets/player/shootup.png"),
				   downshoot_img = love.graphics.newImage("assets/player/shootdown.png"),
				   upreload_img = love.graphics.newImage("assets/player/reloadup.png"),
				   downreload_img = love.graphics.newImage("assets/player/reloaddown.png"),
				   leftreload_img = love.graphics.newImage("assets/player/reloadleft.png"),
				   rightreload_img = love.graphics.newImage("assets/player/reloadright.png"),
				   player_shadows = love.graphics.newImage("assets/player/shadows.png")
				   }

	self.current_image = self.images.up_img 
	self.cooldown = 200
	self.magazine = 15
	self.gameover = false
	self.score = 0
	self.highscore = 0
	self.healthbar = {
					  x = 0,
					  y = 0,
					  width = 100,
					  height = 20
					  }

end

function player:update(dt)

	if self.gameover ~= true then
	
	player:movement(dt)	
	player:bulletupdate(dt)
	player:reload(dt)
	
	end

	player:game_over()
	player:restart()
end

function player:movement(dt)
	self.cooldown = self.cooldown - self.speed * dt

	if love.keyboard.isDown("up") then
		self.current_state = self.states.up
		self.current_image = self.images.up_img
	end

	if love.keyboard.isDown("down") then
		self.current_state = self.states.down
		self.current_image = self.images.down_img
	end

	if love.keyboard.isDown("left") then
		self.current_state = self.states.left
		self.current_image = self.images.left_img
	end

	if love.keyboard.isDown("right") then
		self.current_state = self.states.right
		self.current_image = self.images.right_img
	end

	if self.score >= 0 and self.score <= 25 then
		self.speed = 800
	elseif self.score >= 25 and self.score <= 50 then
		self.speed = 900
	elseif self.score >= 50 and self.score <= 100 then
		self.speed = 1000	
	elseif self.score >= 100 and self.score <= 150 then
		self.speed = 1100
	elseif self.score >= 150 then
		self.speed = 1200		
	end

end

function player:shoot(xoff, yoff, dir)
	if self.cooldown <= 0 then
		love.audio.play(sounds.gunshot)
		self.cooldown = 200
		self.magazine = self.magazine - 1
		bullet = {}
		bullet.x = self.x + xoff
		bullet.y = self.y + yoff
		bullet.width = 1.5
		bullet.height = 1.5
		bullet.direction = dir
		if self.score >= 0 and self.score <= 25 then
			bullet.speed = 100
		elseif self.score >= 25 and self.score <= 50 then
			bullet.speed = 120
		elseif self.score >= 50 and self.score <= 100 then
			bullet.speed = 140
		elseif self.score > 100 then
			bullet.speed = 160
		end
		table.insert(self.bullets, bullet)
	end
end

function player:draw()
	if self.gameover ~= true then
		love.graphics.push()
		love.graphics.scale(5)
		if gudgfx == true then
			love.graphics.setColor(255, 255, 255, 100)
			love.graphics.draw(self.images.player_shadows, self.x, self.y)
		end
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(self.current_image, self.x, self.y)
		player:bulletsdraw()
		love.graphics.pop()
	
		player:reload_draw()
		player:healthdraw()
		player:scoredraw()
	else
		love.graphics.print("GAME OVER \n \n 'R' to restart \n \n 'M' to go to menu \n \n Final Score:"..player.score, 350, 300)
	end
end

function player:bulletsdraw()
	love.graphics.setColor(255, 165, 0)
	for i, b in ipairs(self.bullets) do
		love.graphics.rectangle("fill", b.x, b.y, b.width, b.height)
	end
end

function player:bulletupdate(dt)
if reloading == false then
	if (self.current_state == self.states.up) then 
		if love.keyboard.isDown("z") then
			self.current_image = self.images.upshoot_img
			player:shoot(14.5, 3, "up")
		end
	end

	if (self.current_state == self.states.down) then
		if love.keyboard.isDown("z") then
			self.current_image = self.images.downshoot_img
			player:shoot(14.5, 27, "down")
		end
	end

	if (self.current_state == self.states.left) then
		if love.keyboard.isDown("z") then  
			self.current_image = self.images.leftshoot_img
			player:shoot(1, 14.3, "left")
		end
	end

	if (self.current_state == self.states.right) then
		if love.keyboard.isDown("z") then
			self.current_image = self.images.rightshoot_img
			player:shoot(28, 14.3, "right")
		end
	end
end

	for i, b in pairs(self.bullets) do
		if b.direction == "up" then
			if b.y < 0 then
				table.remove(self.bullets, i)
			end
			b.y = b.y - b.speed * dt
		end

		if b.direction == "down" then
			if b.y > 120 then
				table.remove(self.bullets, i)
			end
			b.y = b.y + b.speed * dt
		end

		if b.direction == "left" then
			if b.x < 0 then
				table.remove(self.bullets, i)
			end
			b.x = b.x - b.speed * dt
		end

		if b.direction == "right" then
			if b.x > 155 then
				table.remove(self.bullets, i)
			end
			b.x = b.x + b.speed * dt
		end
	end
end

function player:reload(dt)
	reloading = false
	local reloadtimer = 50

	if self.magazine <= 0 then
		reloading = true
		self.magazine = 0
		if love.keyboard.isDown("z") then
			love.audio.play(sounds.blank)
		end
	end

	if love.keyboard.isDown("r") then
		love.audio.play(sounds.reload)
		if reloading == true or self.magazine < 15 then
			reloadtimer = reloadtimer - 5000 * dt
			if self.current_state == self.states.up then
				self.current_image = self.images.upreload_img
			end
			if self.current_state == self.states.down then
				self.current_image = self.images.downreload_img
			end
			if self.current_state == self.states.left then
				self.current_image = self.images.leftreload_img
			end
			if self.current_state == self.states.right then
				self.current_image = self.images.rightreload_img
			end
		end
	end

	if reloadtimer <= 0 then
		reloading = false
		self.magazine = 15
	end
end

function player:reload_draw()
	love.graphics.push()
	love.graphics.setFont(myfont)
	love.graphics.setColor(23, 23, 1)
	love.graphics.print("15 of "..math.floor(self.magazine), 700, 2)
	love.graphics.setColor(50, 205, 50)
	if self.magazine <= 5 then
		love.graphics.print("AMMO LOW", 700, 15)
	end
	love.graphics.pop()
end

function player:animation(key)

-- animation reset for shoot

	if key == "z" and self.current_state == self.states.up then
		self.current_image = self.images.up_img
	end
	if key == "z" and self.current_state == self.states.down then
		self.current_image = self.images.down_img
	end
	if key == "z" and self.current_state == self.states.left then
		self.current_image = self.images.left_img
	end
	if key == "z" and self.current_state == self.states.right then
		self.current_image = self.images.right_img
	end

-- animation reset for reload

	if key == "r" and self.current_state == self.states.up then
		self.current_image = self.images.up_img
	end
	if key == "r" and self.current_state == self.states.down then
		self.current_image = self.images.down_img
	end
	if key == "r" and self.current_state == self.states.left then
		self.current_image = self.images.left_img
	end
	if key == "r" and self.current_state == self.states.right then
		self.current_image = self.images.right_img
	end
end

function player:healthdraw()
	self:healthbar_draw()
	love.graphics.setColor(23, 23, 23)
	love.graphics.print("Health :"..math.floor(self.health), 0, 0)
end

function player:game_over()
	if self.health <= 0 then
		love.audio.play(sounds.iamdead)
		self.gameover = true
	end 
end

function player:restart()
	if love.keyboard.isDown("r") and self.gameover == true then
		self.gameover = false
		self.health = 100
		self.magazine = 15 
		self.score = 0
		backgrounds.counter = 0
		enemy.counter = 0
		self.healthbar.width = 100
	end
end

function player:scoredraw()
	love.graphics.print("Score : "..self.score, 150, 1)
end

function player:healthbar_draw()
	love.graphics.setColor(0, 255, 0, 250)
	love.graphics.rectangle("fill", self.healthbar.x, self.healthbar.y, self.healthbar.width, self.healthbar.height)
	love.graphics.setColor(23, 23, 23)
	love.graphics.rectangle("line", self.healthbar.x, self.healthbar.y, self.healthbar.width, self.healthbar.height)
end 

function love.keyreleased(key)
	player:animation(key)
end