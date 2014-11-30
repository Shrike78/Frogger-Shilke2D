local positions = {0.12, 0.89, 0.95, 0.04, 0.04, 0.02, 0.85, 0.53, 0.53, 0.53}
if __USE_SIMULATION_COORDS__ then
	for k,v in ipairs(positions) do
		positions[k] = 1-v
	end
end

GameScreen = class(Screen)

function GameScreen:init(game)
    Screen.init(self,game)
    self._tiers = {}
end

function GameScreen:createScreen()
    if #self._displayObjs == 0 then
        Screen.createScreen(self)
        
        self._hudLayer = DisplayObjContainer()
        
        local sw = self._game:getScreenWidth()
        local sh = self._game:getScreenHeight()
        
        --add bg
        self._bg = GameSprite(self._game, sw/2, sh/2)
        self._bg:setSkin(Image(self._game.imageCache:getTexture("bg.png")))
        self:addChild(self._bg.skin)


        --add tiers (cars, trees, crocodiles, turtles...)
        for i = 1, 12 do
            table.insert(self._tiers, Tier(self._game, i))
        end
        table.insert(self._tiers, FinalTier(self._game, 13))
        
        --add grass
        local grass = GameSprite(self._game, sw * 0.5, sh * positions[1])
        grass:setSkin(Image(self._game.imageCache:getTexture("grass.png")))
        self:addChild(grass.skin)
                
        --add frog
        self._player = Player(self._game, sw * 0.5, sh * positions[2])
        table.insert(self._dynamicElements, self._player)
        
        --add bonus frog 
        self._bonusFrog = BonusFrog (self._game,-100, -100, 
            self._player)
        self._bonusFrog.log = self._tiers[9]:getElement(1)
        table.insert(self._dynamicElements,self._bonusFrog)
                
        --add game timer
        self._timer = LevelTimer(self._game, sw * 0.5, sh * 
            positions[3])
        
        --add score, level, lives
        self._score = NumberSprite (self._game, sw * 0.2, sh * 
            positions[4], 
            "number_score_")
        self._level = NumberSprite (self._game, sw * 0.03, sh * 
            positions[5], 
            "number_level_")
        self._lives = Lives (self._game, sw * 0.68, sh * 
            positions[6])
                
        --add controls
        self._controls = Controls (self._game, sw * 0.82, sh * 
            positions[7])

        --add game labels (game over, new level, game timer)
        self._gameOverMsg = GameSprite(self._game, sw * 0.5, sh * 
            positions[8])
        self._gameOverMsg:setSkin(Image(
            self._game.imageCache:getTexture("game_over_box.png")
--            ,PivotMode.TOP_LEFT
            ))
        self._gameOverMsg:hide()
        self._newLevelMsg = GameSprite(self._game, sw * 0.5, sh *
            positions[9])
        self._newLevelMsg:setSkin(Image(
            self._game.imageCache:getTexture("new_level_box.png")
--            ,PivotMode.TOP_LEFT
            ))
        self._newLevelMsg:hide()
        self:addChild(self._gameOverMsg.skin)
        self:addChild(self._newLevelMsg.skin)
        self._levelTimeMsg = TimeMsg(self._game, sw * 0.5, sh *
            positions[10])
        self._levelTimeMsg:hide()
        --**** TO SHOW SECONDS IN THE MESSAGE ****
        --_levelTimeMsg.timeLabel.showValue(155);
		self:addChild(self._hudLayer)

    --]]
   else
        self._timer:reset()
        self._player:reset()
        self._bonusFrog:reset()
        self._score:reset()
        self._level:reset()
        self._game.gameData:reset()
        self._lives:show()
        for _,tier in ipairs(self._tiers) do
            tier:reset()
        end
    end
    self._score:showValue(0)
    self._level:showValue(1)
            
    --add main input events
    self._controls.skin:addEventListener(Event.TOUCH, 
        GameScreen.onControlTouch, self)

    self._game.gameData.gameMode = Game.GAME_STATE_PLAY
    self._timer:startTimer()
end

function GameScreen:update(dt)
	
	--on desktop uses wasd to move the frog
	if Shilke2D.isDesktop() then
		if not self._player.moveTimer.running then
			if Shilke2D.isKeyPressed('a') then
				self._player:moveFrogLeft()
				self._player.moveTimer:restart()
			elseif Shilke2D.isKeyPressed('d') then
				self._player:moveFrogRight()
				self._player.moveTimer:restart()
			elseif Shilke2D.isKeyPressed('w') then
				self._player:moveFrogUp()
				self._player.moveTimer:restart()
			elseif Shilke2D.isKeyPressed('s') then
				self._player:moveFrogDown()
				self._player.moveTimer:restart()
			end			
		end
	end
	
	
    --update frog and bonus frog
    for _,elem in ipairs(self._dynamicElements) do
        elem:update(dt)
        elem:place()
    end
             
    --update all tiers
    for _,tier in ipairs(self._tiers) do
        tier:update(dt)
    end
             
    if self._player.skin:isVisible() then
        --check collision of frog and tier sprites
        if self._tiers[self._player.tierIndex]:checkCollision(
                self._player) then
            --if tiers with vehicles, and colliding with vehicle
            if self._player.tierIndex < 7 then
                --_game.sounds.play(Sounds.SOUND_HIT);
				self._game.sounds[Sounds.SOUND_HIT]:play()
                --if not colliding with anything in the water tiers, 
                --drown frog
            else
                --_game.sounds.play(Sounds.SOUND_SPLASH);
				self._game.sounds[Sounds.SOUND_SPLASH]:play()
            end
            --kill player
            self._player:kill()
            self._game.gameData.lives = self._game.gameData.lives - 1
            self._lives:updateLives()
        end
        --check collision of frog and bonus frog
        --if bonus frog is visible and not on frog
        if self._bonusFrog.skin:isVisible() then
            if self._bonusFrog:getBounds():intersects(
                    self._player:getBounds()) then
                self._player.hasBonus = true
            end
        end
    else
        if self._player.hasBonus then
            self._bonusFrog:hide()
            self._player.hasBonus = false
        end
    end
    self._timer:update(dt)
end

--kill events
function GameScreen:destroy()
    self._controls.skin:removeEventListener(Event.TOUCH, 
        GameScreen.onControlTouch,self)
end

function GameScreen:updateScore()
    self._score:showValue(self._game.gameData.score)
end
        
function GameScreen:updateLevel()
    self._level:showValue(self._game.gameData.level)
end
        
function GameScreen:gameOver()
    self._gameOverMsg:show()
    self._game.gameData.gameMode = Game.GAME_STATE_PAUSE

    self:setHittable(true)
    self:addEventListener(Event.TOUCH, 
        GameScreen.onRestartGame, self)
end

--when player has reached one of the 5 targets
function GameScreen:targetReached()
            
    --show time for this target
    self._levelTimeMsg.timeLabel:showValue(self._timer:getLevelTime())
    self._levelTimeMsg:show()
    self._levelTimeMsg.timeLabel:show()
    local dcall = DelayedCall(3, function()
            self._levelTimeMsg:hide()
            self._levelTimeMsg.timeLabel:hide()
        end
    )
    juggler:add(dcall)
    self._timer:resetLevelTime()
    self._timer:startTimer()
end

--start new level
function GameScreen:newLevel()
            
    self._game.gameData.gameMode = Game.GAME_STATE_PAUSE
    --increase the speeds in the tiers
    self._game.gameData.tierSpeed1 = 
        self._game.gameData.tierSpeed1 + 0.1
    self._game.gameData.tierSpeed2 = 
        self._game.gameData.tierSpeed2 + 0.2

    self._game.gameData:addLevel()

    for _,tier in ipairs(self._tiers) do
        tier:refresh(dt)
    end

    self._timer:reset()
    self._game.gameData.gameMode = Game.GAME_STATE_PLAY
end

--process touches 
function GameScreen:onControlTouch(event)
    if self._game.gameData.gameMode ~= Game.GAME_STATE_PLAY or 
            not self._player.skin:isVisible() then
        return
    end
    
    local touch = event.touch
    if touch.state == Touch.BEGAN then
        if not self._player.moveTimer.running then
            local dir = self._controls:getDirection(vec2(
                touch.x,touch.y))
            if dir == Player.MOVE_TOP then
                self._player:moveFrogUp()
            elseif dir == Player.MOVE_DOWN then
                self._player:moveFrogDown()
            elseif dir == Player.MOVE_LEFT then
                self._player:moveFrogLeft()
            elseif dir == Player.MOVE_RIGHT then
                self._player:moveFrogRight()
            end
            self._player.moveTimer:reset()
            self._player.moveTimer:start()
        end
    end
end


--after game over, if player clicks the stage we switch to Menu Screen
function GameScreen:onRestartGame(event)
    local touch = event.touch
    if touch.state == Touch.ENDED then
        self:setHittable(false)
        self:removeEventListener(Event.TOUCH, 
            GameScreen.onRestartGame,self)
        self._gameOverMsg:hide()
        self._game:setScreen(MenuScreen)
    end
end
    