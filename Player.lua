-- Player

Player = class(MovingSprite)

Player.MOVE_TOP = 0
Player.MOVE_DOWN = 1
Player.MOVE_LEFT = 2
Player.MOVE_RIGHT = 3
        
function Player:init(game,x,y)
    MovingSprite.init(self,game,x,y)
    
    self._startPoint = vec2(x,y)
    
    self.tierSpeed = 0
    self.dead = false
        
    self.moveLeft = false
    self.moveRight = false
    self.moveUp = false
    self.moveDown = false
        
    self.tierIndex = 1
    self.hasBonus = false

    self._sideStep = 22
    
    -- store textures for frog
    self._frogStand = game.imageCache:getTexture("frog_stand.png")
    self._frogJump = game.imageCache:getTexture("frog_jump.png")
    self._frogSide = game.imageCache:getTexture("frog_side.png")
    self._frogSideJump = game.imageCache:getTexture("frog_side_jump.png")
    self._restFrame = self._frogStand
    
    -- death animation
    --Todo: movieclip da verificare
    local dieFrames = game.imageCache:getTextures("death_")
    local _deathAnimation = MovieClip(dieFrames, 4)
    self._deathAnimation = _deathAnimation
    --_deathAnimation.setFrameDuration(#dieFrames - 1, 1)
    _deathAnimation:setVisible(false)
--    _deathAnimation:setRepetitionCount(1)
    _deathAnimation:addEventListener(Event.COMPLETED,
        Player.onDeathComplete,self)
    _deathAnimation:stop()
    juggler:add(_deathAnimation)
    
    --self.moveTimer = DelayedCall(0.2,Player.onFrogRest,self)
    self.moveTimer = Timer(0.2,1)
    self.moveTimer:addEventListener(Event.TIMER,Player.onFrogRest,self)
    juggler:add(self.moveTimer)
    
    self:setSkin(Image(self._frogStand))
            
    game:getScreen():addChild(self.skin)
    game:getScreen():addChild(self._deathAnimation)
    --Todo: verify set/getPosition
    _deathAnimation:setPosition(self.skin:getPosition())
    
end

function Player:reset()

    self.x = self._startPoint.x
    self.nextX = self._startPoint.x
    self.skin:setPositionX(self._startPoint.x)
    
    self.y = self._startPoint.y
    self.nextY = self._startPoint.y
    self.skin:setPositionY(self._startPoint.y)
    
    self.hasBonus = false
    self.dead = false
    self.skin:setTexture(self._frogStand)
    self:show()
    self.tierIndex = 1
    self.skin:setScale(1,1)
end

function Player:moveFrogUp()
    if (not self.moveTimer.running) then
        self.tierIndex = self.tierIndex + 1
        if self.tierIndex > #Tier.TIER_Y then
            self.tierIndex = #Tier.TIER_Y
        else
            self._game.gameData:addScore(GameData.POINTS_JUMP)
            --self._game.sounds:play(Sounds.SOUND_JUMP)
            self._game.sounds[Sounds.SOUND_JUMP]:play()
        end
if __USE_SIMULATION_COORDS__ then		
        self.nextY = Tier.TIER_Y[self.tierIndex] - self.skin:getHeight()*0.5
else
        self.nextY = Tier.TIER_Y[self.tierIndex] + self.skin:getHeight()*0.5
end
        self.moveTimer:reset()
        self.moveTimer:start()
        juggler:add(self.moveTimer)
        self:showMoveFrame(MovingSprite.UP)
        self.moveUp = false
    end
end

function Player:moveFrogDown()
    if (not self.moveTimer.running) then
        self.tierIndex = self.tierIndex - 1
        if self.tierIndex < 1 then
            self.tierIndex = 1
        else
            self._game.gameData:addScore(GameData.POINTS_JUMP)
            --self._game.sounds:play(Sounds.SOUND_JUMP)
			self._game.sounds[Sounds.SOUND_JUMP]:play()
        end
if __USE_SIMULATION_COORDS__ then		
        self.nextY = Tier.TIER_Y[self.tierIndex] - self.skin:getHeight()*0.5
else
        self.nextY = Tier.TIER_Y[self.tierIndex] + self.skin:getHeight()*0.5
end
        self.moveTimer:reset()
        self.moveTimer:start()
        juggler:add(self.moveTimer)
        self:showMoveFrame(MovingSprite.DOWN)
        self.moveDown = false
   end
end

function Player:moveFrogLeft()
    if (not self.moveTimer.running) then
        self.nextX = self.nextX - self._sideStep
        self.moveTimer:reset()
        self.moveTimer:start()
        juggler:add(self.moveTimer)
        self:showMoveFrame(MovingSprite.LEFT)
        --self._game.sounds:play(Sounds.SOUND_JUMP)
		self._game.sounds[Sounds.SOUND_JUMP]:play()
        self.moveLeft = false
   end
end

function Player:moveFrogRight()
    if (not self.moveTimer.running) then
        self.nextX = self.nextX + self._sideStep
        self.moveTimer:reset()
        self.moveTimer:start()
        juggler:add(self.moveTimer)
        self:showMoveFrame(MovingSprite.RIGHT)
        --self._game.sounds:play(Sounds.SOUND_JUMP)
		self._game.sounds[Sounds.SOUND_JUMP]:play()
        self.moveRight = false
   end
end

function Player:update(dt)

    --play animation if dead
    if self.dead then            
        return
    end
    --add tier speed if player is on top of a moving object
    self.nextX = self.nextX + self.tierSpeed * dt
            
    --listen for input
    if self.moveLeft then
        self:moveFrogLeft()
    elseif self.moveRight then
        self:moveFrogRight()
    elseif self.moveUp then
        self:moveFrogUp()
    elseif self.moveDown then
        self:moveFrogDown()
    end
            
    self:place()

    if show_player_bbox then
        self:drawBounds()
    end
end

function Player:place()
    --limit movement if player is not on water Tiers so frog 
    --does not leave the screen
    if self.tierIndex < 8 then
        if self.nextX < self.skin:getWidth() * 0.5 then
            self.nextX = self.skin:getWidth() * 0.5
        end
        if self.nextX > self._game:getScreenWidth() - 
                self.skin:getWidth() * 0.5 then
                    
            self.nextX = self._game:getScreenWidth() - 
                self.skin:getWidth() * 0.5
        end
    else
    --make player go back to start if frog leaves screen on water Tiers
        if self.nextX < -self.skin:getWidth() * 0.5 or 
                self.nextX > self._game:getScreenWidth() + 
                self.skin:getWidth()*0.5 then
            --self._game.sounds.play(Sounds.SOUND_OUTOFBOUNDS);
			self._game.sounds[Sounds.SOUND_OUTOFBOUNDS]:play()
            self:reset()
        end                
    end
    MovingSprite.place(self)
end

function Player:kill()
    self.tierSpeed = 0
            
    self._game.gameData.gameMode = Game.GAME_STATE_ANIMATE
    self.moveLeft = false
    self.moveRight = false
    self.moveUp = false
    self.moveDown = false
    self.skin:setVisible(false)
            
    self._deathAnimation:setPosition(self.skin:getPosition())
    self._deathAnimation:setVisible(true)

    self.dead = true
    self._deathAnimation:stop()
    self._deathAnimation:play()
end

function Player:showMoveFrame(dir)
    if dir == MovingSprite.LEFT then
        self.skin:setScaleX(-1)
        self.skin:setTexture(self._frogSideJump)
        self._restFrame = self._frogSide
    elseif dir == MovingSprite.RIGHT then
        self.skin:setScaleX(1)
        self.skin:setTexture(self._frogSideJump)
        self._restFrame = self._frogSide
    elseif dir == MovingSprite.UP then
        self.skin:setScaleY(1)
        self.skin:setTexture(self._frogJump)
        self._restFrame = self._frogStand
    elseif dir == MovingSprite.DOWN then
        self.skin:setScaleY(-1)
        self.skin:setTexture(self._frogJump)
        self._restFrame = self._frogStand
    end
end

function Player:onFrogRest()
    self.skin:setTexture(self._restFrame)
end

--to be used with MovieClip
function Player:onDeathComplete(event)
    self._deathAnimation:setVisible(false)
    if self._game.gameData.lives >= 0 then
        local dcall = DelayedCall(0.5, function()
                self:reset()
                self._game.gameData.gameMode = Game.GAME_STATE_PLAY
            end
        )
        juggler:add(dcall)
    else
        self._game:getScreen():gameOver()
    end
end