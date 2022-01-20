enemy = {}

function enemy:load()
	self.images = {
				   enemyup = love.graphics.newImage("assets/enemy/zombieup.png"),
				   enemydown = love.graphics.newImage("assets/enemy/zombiedown.png"),
				   enemyleft = love.graphics.newImage("assets/enemy/zombieleft.png"),
				   enemyright = love.graphics.newImage("assets/enemy/zombieright.png"),
				   enemy_shadows = love.graphics.newImage("assets/enemy/shadows.png")
				   }
	self.current_image = self.images.enemyup
	self.up = 200
	self.down = 357
	self.left = 492
	self.right = 653
	self.spawn_point = {}
	self.counter = 0

	enemy:anim_l()
end

function enemy:spawn(x, y, dir, img, spritesheet)
	love.audio.play(sounds.zombiespawn)
	zombie = {}
	zombie.x = x 
	zombie.y = y 
	zombie.xoff = 0
	zombie.yoff = 0
	zombie.width = 16  
	zombie.height = 16 
	zombie.direction = dir
	zombie.states = {walk = "walk",
					 death = "death"}
	zombie.current_state = zombie.states.walk
	zombie.image = img
	zombie.death_anim = spritesheet
	zombie.fps = 6
	zombie.anim_timer = 1 / zombie.fps
	zombie.current_sprite = love.graphics.newQuad(zombie.xoff, zombie.yoff, 32, 32, zombie.death_anim:getDimensions())

	if player.score >= 0 and player.score <= 25 then 
		zombie.speed = 100
	elseif player.score >= 25 and player.score <= 50 then
		zombie.speed = 110
	elseif player.score >= 50 and player.score <= 100 then
		zombie.speed = 120
	elseif player.score >= 100 and player.score <= 150 then
		zombie.speed = 150
	elseif player.score >= 150 then
		zombie.speed = 180
	end
	if player.score >= 0 and player.score <= 25 then 
		zombie.damage = 10
	elseif player.score >= 25 and player.score <= 50 then
		zombie.damage = 50
	elseif player.score >= 50 and player.score <= 100 then
		zombie.damage = 100
	elseif player.score > 100 then
		zombie.damage = 150
	end
	table.insert(self.spawn_point, zombie)
end

function enemy:update(dt)
	if player.gameover ~= true then
	
	self.up = self.up - 100 * dt
	self.down = self.down - 100 * dt
	self.left = self.left - 100 * dt
	self. right = self.right - 100 * dt

	enemy:collide(dt)
	
	end

	enemy:run(dt)
end

function enemy:draw()
	if player.gameover ~= true then
	love.graphics.push()
	love.graphics.scale(5)
	for _, e in pairs(self.spawn_point) do
		if gudgfx == true then
			love.graphics.setColor(255, 255, 255, 100)
			love.graphics.draw(self.images.enemy_shadows, e.x, e.y)
		end
		if e.current_state == e.states.walk then
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(e.image, e.x, e.y)
		end
		enemy:anim_d(e)
	end
	enemy:collide_draw()
	love.graphics.pop()
	end
end

function enemy:run(dt)
	if self.up <= 0 then
		self.up = 200
		enemy:spawn(65, -10, "up", self.images.enemyup, _death_down)	
	end

	if self.down <= 0 then
		self.down = 300
		enemy:spawn(65, 105, "down", self.images.enemydown, _death_up)	
	end

	if self.left <= 0 then
		self.left = 400
		enemy:spawn(-5, 45, "left", self.images.enemyleft, _death_left)	
	end

	if self.right <= 0 then
		self.right = 500
		enemy:spawn(150, 45, "right", self.images.enemyright, _death_right)	
	end

	for i, e in ipairs(self.spawn_point) do
		if e.current_state == e.states.walk then
			if e.direction == "up" then
				if e.y > 90 or player.gameover == true then 
					table.remove(self.spawn_point, i)
				end
				e.y = e.y + e.speed * dt
			end
			if e.direction == "down" then
				if e.y < 0 or player.gameover == true then 
					table.remove(self.spawn_point, i)
				end
				e.y = e.y - e.speed * dt
			end
			if e.direction == "left" then
				if e.x > 110 or player.gameover == true then 
					table.remove(self.spawn_point, i)
				end
				e.x = e.x + e.speed * dt
			end
			if e.direction == "right" then
				if e.x < 0 or player.gameover == true then 
					table.remove(self.spawn_point, i)
				end
				e.x = e.x - e.speed * dt
			end
		end
	end
end

function enemy:collide(dt)
	for i, b in ipairs(player.bullets) do
		for i, e in ipairs(self.spawn_point) do
			if CheckCollision(b.x / 5, b.y / 5, b.width / 5, b.height / 5 , e.x / 5, e.y / 5, e.width / 5, e.height / 5) then
				love.audio.play(sounds.zombiedeath)
				e.current_state = e.states.death
				table.remove(player.bullets)
			end
		end
	end

	for i, e in ipairs(self.spawn_point) do
		if CheckCollision(e.x / 5, e.y, e.width / 5, e.height / 5, player.x / 5, 
			player.y, player.width / 5, player.height / 5) and e.current_state == e.states.walk then
			player.health = player.health - e.damage 
		end
	end

	for i, e in ipairs(self.spawn_point) do
		enemy:anim_u(dt, e, i)
	end

	if self.counter == 25 then
		player.health = 100
		player.healthbar.width = 100
		self.counter = 0
	end
end

function enemy:collide_draw()
	love.graphics.setColor(255, 0, 0, 100)
	for i, e in ipairs(self.spawn_point) do
		if CheckCollision(e.x / 5, e.y, e.width / 5, e.height / 5, player.x / 5, player.y, player.width / 5, player.height / 5) then
			love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		end
	end
end

function enemy:anim_l()
	self.death_anims = {up = love.graphics.newImage("assets/enemy/death_up.png"),
				   down = love.graphics.newImage("assets/enemy/death_down.png"),
				   left = love.graphics.newImage("assets/enemy/death_left.png"),
				   right = love.graphics.newImage("assets/enemy/death_right.png")}

	_death_up = enemy.death_anims.up
	_death_down = enemy.death_anims.down
	_death_left = enemy.death_anims.left
	_death_right = enemy.death_anims.right
end

function enemy:anim_u(dt, enemy_t, index)
	enemy_t.anim_timer = enemy_t.anim_timer - dt
	if enemy_t.current_state == enemy_t.states.death then
		if enemy_t.anim_timer <= 0 then
			enemy_t.anim_timer = 1 / enemy_t.fps

			enemy_t.xoff = enemy_t.xoff + 32
			
			if enemy_t.xoff >= 128 then
				table.remove(self.spawn_point, index)
				enemy:death_u()
			end

			enemy_t.current_sprite = love.graphics.newQuad(enemy_t.xoff, enemy_t.yoff, 32, 32, enemy_t.death_anim:getDimensions())
		end
	end
end

function enemy:death_u()
	player.score = player.score + 1
	self.counter = self.counter + 1
	backgrounds.counter = backgrounds.counter + 1
end

function enemy:anim_d(enema)
	if enema.current_state == enema.states.death then
		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(enema.death_anim, enema.current_sprite, enema.x, enema.y)
	end
end