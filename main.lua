require("AnAL")

function love.load()

   love.keyboard.setKeyRepeat(true)
   warrior = {}
   monsters = {}
   monsters.imp = {}
   
   -- Sprites --

   background = love.graphics.newImage("sprites/background.png")

   warrior.sprite = {}
   warrior.sprite.left = love.graphics.newImage("sprites/bull_warrior_spritesheet_left.png")
   warrior.sprite.right = love.graphics.newImage("sprites/bull_warrior_spritesheet_right.png")
   warrior.sprite.health = love.graphics.newImage("sprites/heart.png")
   warrior.sprite.anim_left = newAnimation(warrior.sprite.left, 149, 224, 0.2, 0)
   warrior.sprite.anim_right = newAnimation(warrior.sprite.right, 149, 224, 0.2, 0)
   warrior.sprite.anim_left:setMode("bounce")
   warrior.sprite.anim_right:setMode("bounce")
   
   monsters.imp.sprite = {}
   monsters.imp.sprite.left = love.graphics.newImage("sprites/monster_ground_small_left.png")
   monsters.imp.sprite.right = love.graphics.newImage("sprites/monster_ground_small_right.png")
   monsters.imp.sprite.anim_left = newAnimation(monsters.imp.sprite.left, 133, 165, 0.2, 0)
   monsters.imp.sprite.anim_right = newAnimation(monsters.imp.sprite.right, 133, 165, 0.2, 0)
   monsters.imp.sprite.anim_left:setMode("bounce")
   monsters.imp.sprite.anim_right:setMode("bounce")

   -- Collisions --
   plateforms = {}

   newPlateform(plateforms, {0, 835, 280, 835, 280, 920, 0, 920})
   plateforms[0] = {}
   plateforms[0].x1 = 0
   plateforms[0].y1 = 835
   plateforms[0].x2 = 280
   plateforms[0].y2 = plateforms[0].y1
   plateforms[0].x3 = plateforms[0].x2
   plateforms[0].y3 = 920
   plateforms[0].x4 = plateforms[0].x1
      plateforms[0].y4 = plateforms[0].y3

   plateforms[1] = {}
   plateforms[1].x1 = plateforms[0].x3
   plateforms[1].y1 = plateforms[0].y3
   plateforms[1].x2 = plateforms[1].x1 + 140
   plateforms[1].y2 = plateforms[1].y1
   plateforms[1].x3 = plateforms[1].x2
   plateforms[1].y3 = plateforms[0].y3 + 40
   plateforms[1].x4 = plateforms[1].x1
   plateforms[1].y4 = plateforms[1].y3

   plateforms[2] = {} -- Central plateform, at the bottom of the background --
   plateforms[2].x1 = plateforms[1].x3
   plateforms[2].y1 = plateforms[1].y3
   plateforms[2].x2 = plateforms[2].x1 + 1020
   plateforms[2].y2 = plateforms[2].y1
   plateforms[2].x3 = plateforms[2].x2
   plateforms[2].y3 = plateforms[1].y3 + 100
   plateforms[2].x4 = plateforms[2].x1
   plateforms[2].y4 = plateforms[2].y3

   plateforms[3] = {}
   plateforms[3].x1 = plateforms[2].x3
   plateforms[3].y1 = plateforms[1].y1 - 10
   plateforms[3].x2 = plateforms[3].x1 + 155
   plateforms[3].y2 = plateforms[3].y1
   plateforms[3].x3 = plateforms[3].x2
   plateforms[3].y3 = plateforms[2].y2
   plateforms[3].x4 = plateforms[3].x1
   plateforms[3].y4 = plateforms[3].y3

   plateforms[4] = {}
   plateforms[4].x1 = plateforms[3].x3
   plateforms[4].y1 = plateforms[0].y1 - 10
   plateforms[4].x2 = 1920
   plateforms[4].y2 = plateforms[4].y1
   plateforms[4].x3 = plateforms[4].x2
   plateforms[4].y3 = plateforms[3].y2
   plateforms[4].x4 = plateforms[4].x1
   plateforms[4].y4 = plateforms[4].y3

   plateforms[5] = {}
   plateforms[5].x1 = 550
   plateforms[5].y1 = 610
   plateforms[5].x2 = 1290
   plateforms[5].y2 = plateforms[5].y1
   plateforms[5].x3 = plateforms[5].x2
   plateforms[5].y3 = plateforms[5].y2 + 50
   plateforms[5].x4 = plateforms[5].x1
      plateforms[5].y4 = plateforms[5].y3
   
   -- Movement --
   warrior.pos = {}
   warrior.pos.x = plateforms[5].x2 / 2
   warrior.pos.y = plateforms[5].y1 - warrior.sprite.anim_left:getHeight()
   warrior.pos.max_x = warrior.pos.x + warrior.sprite.anim_left:getWidth()
   warrior.pos.max_y = warrior.pos.y + warrior.sprite.anim_left:getHeight()
   warrior.pos.tail = 75
   warrior.pos.direction = "left"
   warrior.pos.speed = 10
   warrior.pos.move = false

   monsters.imp.pos = {}
   monsters.imp.pos.x = 900
   monsters.imp.pos.y = 600
   monsters.imp.pos.max_x = monsters.imp.pos.x + monsters.imp.sprite.anim_left:getWidth()
   monsters.imp.pos.max_y = monsters.imp.pos.y + monsters.imp.sprite.anim_left:getHeight()
   monsters.imp.pos.tail = 0
   monsters.imp.pos.direction = "right"
   monsters.imp.pos.speed = 5
   monsters.imp.pos.move = false
   
   warrior.jump = {}
   warrior.jump.had_jumped = false
   warrior.jump.height = 300
   warrior.jump.speed = 30
   warrior.jump.old_pos = warrior.pos.max_y

   monsters.imp.jump = {}
   monsters.imp.jump.had_jumped = false
   monsters.imp.jump.height = 300
   monsters.imp.jump.speed = 30
   monsters.imp.jump.old_pos = monsters.imp.pos.max_y

   -- Fight --
   warrior.fight = {}
   warrior.fight.health = 5
   warrior.fight.hit = false
   warrior.fight.range = 10
   warrior.fight.invincibility = 0
   
   monsters.imp.fight = {}
   monsters.imp.fight.health = 2
   monsters.imp.fight.hit = false
   monsters.imp.fight.range = 2
   monsters.imp.fight.invincibility = 0
   
   aff_hitbox = false
end

function love.update(dt)
   warrior.sprite.anim_left:update(dt)
   warrior.sprite.anim_right:update(dt)
   monsters.imp.sprite.anim_left:update(dt)
   monsters.imp.sprite.anim_right:update(dt)

   warrior.pos.max_x = warrior.pos.x + warrior.sprite.anim_left:getWidth()
   warrior.pos.max_y = warrior.pos.y + warrior.sprite.anim_left:getHeight()
   monsters.imp.pos.max_x = monsters.imp.pos.x + monsters.imp.sprite.anim_left:getWidth()
   monsters.imp.pos.max_y = monsters.imp.pos.y + monsters.imp.sprite.anim_left:getHeight()

   if (monsters.imp.pos.x + monsters.imp.sprite.anim_left:getWidth() / 2 > warrior.pos.x + warrior.sprite.anim_left:getWidth() / 2) then
      monsters.imp.pos.direction = "left"
   else
      monsters.imp.pos.direction = "right"
   end

   checkJump(warrior)
   checkJump(monsters.imp)
   checkCollisionsEntities(warrior, monsters.imp, dt)
   checkCollisions(warrior)
   if (checkCollisions(monsters.imp)) then
      monsters.imp.jump.bool = true
   end
end

function love.keypressed(key, isrepeat)
   if (key == "escape") then
      love.event.quit()
   end

   if (key == "d") then
      warrior.pos.move = true
      warrior.pos.direction = "right"
   elseif (key == "q") then
      warrior.pos.move = true
      warrior.pos.direction = "left"
   elseif (key == "z" and not warrior.jump.bool) then
      warrior.jump.bool = true
      warrior.jump.had_jumped = false
      warrior.jump.old_pos = warrior.pos.max_y
   end
   
   if (key == "m") then
      aff_hitbox = not aff_hitbox
   end
end

function love.keyreleased(key)
   if (key == "q" or key == "d") then
      warrior.pos.move = false
   end
end

function love.draw()
   love.graphics.draw(background, 0, 0)

   for i = 1, warrior.fight.health do
      love.graphics.draw(warrior.sprite.health, 20 + warrior.sprite.health:getWidth() * (i - 1) * 0.3, 20, 0, 0.3)
   end

   if (round(warrior.fight.invincibility * 10, 0) % 2 == 0) then
      if (warrior.pos.direction == "left") then
	 warrior.sprite.anim_left:draw(warrior.pos.x, warrior.pos.y)
      elseif (warrior.pos.direction == "right") then
	 warrior.sprite.anim_right:draw(warrior.pos.x, warrior.pos.y)
      end
   end

   if (round(monsters.imp.fight.invincibility * 10, 0) % 2 == 0) then
      if (monsters.imp.pos.direction == "left") then
	 monsters.imp.sprite.anim_left:draw(monsters.imp.pos.x, monsters.imp.pos.y)
      elseif (monsters.imp.pos.direction == "right") then
	 monsters.imp.sprite.anim_right:draw(monsters.imp.pos.x, monsters.imp.pos.y)
      end
   end
   
      -- Press "m" to see all hitboxes ! --
   if (aff_hitbox) then affHitboxes() end
end

function checkJump(entity)
   if (entity.jump.bool and not entity.jump.had_jumped) then
      if (entity.jump.old_pos - entity.jump.height < entity.pos.max_y) then
	 entity.pos.y = entity.pos.y - entity.jump.speed
      else
	 entity.jump.had_jumped = true
      end
   end
end

function checkCollisions(entity)
   local check = getPlateform(entity)

   if not (check == -1) then
      if (entity.pos.max_y < plateforms[check].y1) then
	 entity.pos.y = entity.pos.y + entity.jump.speed / 2
      else
	 if (entity.jump.had_jumped) then
	    entity.jump.bool = false
	 end
	 entity.jump.had_jumped = false
      end
      
      if (entity.pos.move) then
	 if (entity.pos.direction == "left") then
	    if (check == 0) then
	       if not (entity.pos.x < 20) then
		  entity.pos.x = entity.pos.x - entity.pos.speed
	       else
		  return (true)
	       end
	    elseif (check == 5) then
	       entity.pos.x = entity.pos.x - entity.pos.speed
	    else
	       if not (entity.pos.x <= plateforms[check - 1].x2 and entity.pos.max_y >= plateforms[check - 1].y1) then
		  entity.pos.x = entity.pos.x - entity.pos.speed
	       else
		  return (true)
	       end
	    end
	    
	 elseif (entity.pos.direction == "right") then
	    if (check == 4) then
	       if not (entity.pos.max_x > 1900) then
		  entity.pos.x = entity.pos.x + entity.pos.speed
	       else
		  return (true)
	       end
	    elseif (check == 5) then
	       entity.pos.x = entity.pos.x + entity.pos.speed
	    else
	       if not (entity.pos.max_x >= plateforms[check + 1].x1 and entity.pos.max_y >= plateforms[check + 1].y1) then
		  entity.pos.x = entity.pos.x + entity.pos.speed
	       else
		  return (true)
	       end
	    end
	 end
      end
   end
end

function checkCollisionsEntities(entity1, entity2, dt)
   if (entity2.pos.direction == "left") then							-- If the monster looks at the left --
      if (entity2.pos.x > entity1.pos.max_x - entity1.pos.tail) then				-- And isn't at the contact of the player's hitbox --
	 entity2.pos.move = true 
      else
	 entity2.pos.move = false
	 if (entity1.pos.max_y > entity2.pos.max_y) then					-- If the player is above the monster --
	    if (entity2.pos.y >= entity1.pos.y and entity2.pos.y <= entity1.pos.max_y) then     -- And the monster's hitbox collide with the player's ones --
	       entity1.fight.hit = true
	    end
	 elseif (entity1.pos.max_y > entity2.pos.max_y) then					-- If the player is under the monster --
	    if (entity2.pos.y >= entity1.pos.y and entity2.pos.y <= entity1.pos.max_y) then     -- And the monster's hitbox collide with the player's ones --
	       entity1.fight.hit = true
	    end
	 end
      end
      
   elseif (entity2.pos.direction == "right") then						-- If the monster looks at the left --
      if (entity2.pos.max_x < entity1.pos.x + entity1.pos.tail) then				-- And isn't at the contact of the player's hitbox --
	 entity2.pos.move = true
      else
	 entity2.pos.move = false
	 if (entity1.pos.max_y > entity2.pos.max_y) then					-- If the player is above the monster --
	    if (entity2.pos.y >= entity1.pos.y and entity2.pos.y <= entity1.pos.max_y) then     -- And the monster's hitbox collide with the player's ones --
	       entity1.fight.hit = true
	    end
	 elseif (entity1.pos.max_y > entity2.pos.max_y) then					-- If the player is under the monster --
	    if (entity2.pos.y >= entity1.pos.y and entity2.pos.y <= entity1.pos.max_y) then     -- And the monster's hitbox collide with the player's ones --
	       entity1.fight.hit = true
	    end
	 end
      end
   end

   -- Put a invincibility frame --
   if (entity1.fight.hit and entity1.fight.invincibility <= 0) then
      entity1.fight.invincibility = 2
      entity1.fight.health = entity1.fight.health - 1
   elseif (entity1.fight.hit and entity1.fight.invincibility > 0) then
      entity1.fight.invincibility = entity1.fight.invincibility - dt
   end

   if (entity1.fight.invincibility < 0) then
      entity1.fight.hit = false
      entity1.fight.invincibility = 0
   end
end

function getPlateform(entity)
   local i = 5

   while (plateforms[i]) do
      if (entity.pos.direction == "left") then
	 if (entity.pos.max_x - entity.pos.tail >= plateforms[i].x1 and entity.pos.max_x - entity.pos.tail <= plateforms[i].x2 and entity.pos.max_y - entity.jump.speed / 2 <= plateforms[i].y1) then
	    return (i)
	 end
      elseif (entity.pos.direction == "right") then
	 if (entity.pos.x + entity.pos.tail >= plateforms[i].x1 and entity.pos.x + entity.pos.tail <= plateforms[i].x2 and entity.pos.max_y - entity.jump.speed / 2 <= plateforms[i].y1) then
	    return (i)
	 end
      end

      i = i - 1
   end
   return (-1)
end

function affHitboxes()
   local i = 0

   love.graphics.setColor(0, 255, 0)
   if (warrior.pos.direction == "left") then
      love.graphics.line(warrior.pos.x, warrior.pos.y, warrior.pos.max_x - warrior.pos.tail, warrior.pos.y,
			 warrior.pos.max_x - warrior.pos.tail, warrior.pos.max_y, warrior.pos.x, warrior.pos.max_y,
			 warrior.pos.x, warrior.pos.y)
   elseif (warrior.pos.direction == "right") then
      love.graphics.line(warrior.pos.x + warrior.pos.tail, warrior.pos.y, warrior.pos.max_x, warrior.pos.y,
			 warrior.pos.max_x, warrior.pos.max_y, warrior.pos.x + warrior.pos.tail, warrior.pos.max_y,
			 warrior.pos.x + warrior.pos.tail, warrior.pos.y)
   end
   
   love.graphics.setColor(255, 0, 0)
   love.graphics.line(monsters.imp.pos.x, monsters.imp.pos.y, monsters.imp.pos.max_x, monsters.imp.pos.y,
		      monsters.imp.pos.max_x, monsters.imp.pos.max_y, monsters.imp.pos.x, monsters.imp.pos.max_y,
		      monsters.imp.pos.x, monsters.imp.pos.y)
   
   love.graphics.setColor(0, 0, 255)
   while (plateforms[i]) do
      love.graphics.line(plateforms[i].x1, plateforms[i].y1, plateforms[i].x2, plateforms[i].y2,
			 plateforms[i].x3, plateforms[i].y3, plateforms[i].x4, plateforms[i].y4,
			 plateforms[i].x1, plateforms[i].y1)
      i = i + 1
   end
   love.graphics.setColor(255, 255, 255)
end

function round(num, dec)
   local mult = 10^(dec or 0)
   return math.floor(num * mult + 0.5) / mult
end

function newPlateform(object, vectices)
   local i = 1

   while (object[i]) do i = i + 1 end

   object[i] = {}
   object[i].x1 = vectices[1]
   object[i].y1 = vectices[2]
   object[i].x2 = vectices[3]
   object[i].y2 = vectices[4]
   object[i].x3 = vectices[5]
   object[i].y3 = vectices[6]
   object[i].x4 = vectices[7]
   object[i].y4 = vectices[8]

   return (object)
end
