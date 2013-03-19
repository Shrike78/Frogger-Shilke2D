-- LevelTimer

LevelTimer = class(GameSprite)

function LevelTimer:init(game,x,y)
    GameSprite.init(self,game,x,y)
    
    self._timeWidth = 160
    self._seconds = 0
    
    self._timeLabel = Image(game.imageCache:getTexture("label_time.png")
        ,PivotMode.BOTTOM_LEFT
    )
    self._timeLabel:setPositionX(self.x - game:getScreenWidth() * 0.45)
    self._timeLabel:setPositionY(self.y)
    
    self._timeBar = Quad(self._timeWidth, 10                
        ,PivotMode.BOTTOM_LEFT
    )
    self._timeBar:setColor(0,255,0,255)
    self._timeBar:setPositionX(self.x - game:getScreenWidth() * 0.3)
    self._timeBar:setPositionY(self.y + self._timeBar:getHeight() * 0.2)
    
    --game:getScreen():addChild(self._timeLabel)
    --game:getScreen():addChild(self._timeBar)
    game:getScreen()._hudLayer:addChild(self._timeLabel)
    game:getScreen()._hudLayer:addChild(self._timeBar)
    
    self._timeDecrement = self._timeWidth*0.004
	
    local dcall = DelayedCall(1,LevelTimer.onTickTock,self)
    self._timer = Tween.loop(dcall,-1)
    self._juggler = Juggler()
    juggler:add(self._juggler)
    self._juggler:add(self._timer)
end

function LevelTimer:pauseTimer()
    self._juggler:setPause(true)
end

function LevelTimer:startTimer()
    self._timer:reset()
    self._juggler:setPause(false)
end

function LevelTimer:reset()
    self:resetLevelTime()
    self._timeBar:setScaleX(1)
    self._timeBar:setVisible(true)
end

function LevelTimer:resetLevelTime()
    self._seconds = 0
end

function LevelTimer:getLevelTime()
    return self._seconds
end

function LevelTimer:update(dt)
    if self._game.gameData.gameMode == Game.GAME_STATE_PLAY then
        if self._juggler:isPaused() then
            self:startTimer()
        end
    else
        if not self._juggler:isPaused() then
            self:pauseTimer()
        end
    end
end

function LevelTimer:onTickTock(event)
    self._seconds = self._seconds + 1
    if self._timeBar:getWidth() - self._timeDecrement <= 0 then
        self._game:getScreen():gameOver()
        self._timeBar:serVisible(false)
        self:pauseTimer()
    else
        local v = self._timeBar:getWidth() - self._timeDecrement
        self._timeBar:setScaleX(v/self._timeBar:getBounds(
            self._timeBar).w)
    end
end