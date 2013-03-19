-- BonusFrog

BonusFrog = class(MovingSprite)

function BonusFrog:init(game,x,y,frog)
    MovingSprite.init(self,game,x,y)
    self._animationCnt = 0
    self._xMove = 0
    self._frog = frog
    self._frogStand = game.imageCache:getTexture("frog_bonus_stand.png")
    self._frogSide = game.imageCache:getTexture("frog_bonus_side.png")
    self:setSkin(Image(self._frogStand))
    game:getScreen():addChild(self.skin)
    self.body = Rect(0,0, self.skin:getWidth()/2, 
        self.skin:getHeight()/2)
    self:hide()
    self._animationInterval = math.random() * 30
end

function BonusFrog:reset()
    self:hide()
    self._animationCnt = 0
end

function BonusFrog:update(dt)
    if not self.log then
        return
    end
    
    if self.skin:isVisible() then
        if self._frog.hasBonus then
            --if on frog already, move with frog
            self.nextX = self._frog.nextX
            self.nextY = self._frog.nextY
        else
            self.nextX = self.log.nextX + self._xMove
            self.nextY = self.log.nextY
            --else, still on log, move with log
            if self._animationCnt > self._animationInterval then
                local random = math.floor(math.random() * 5)
                if random == 0 then
                    self:move()
                elseif random == 1 then
                    if self.skin.texture == self._frogSide then
                        self.skin:setTexture(self._frogStand)
                    end
                elseif random == 2 then
                    self:move()
                elseif random == 3 then
                    if self.skin.texture == self._frogStand then
                        self.skin:setTexture(self._frogSide)
                    end
                elseif random == 4 then
                    if self.skin:getScaleX() < 0 then
                        self.skin:setScaleX(1)
                    end
                    if self.skin:getScaleY() < 0 then
                        self.skin:setScaleY(1)
                    end
                    self:move()
                end
                self._animationInterval = math.floor(
                    math.random() * 50)
                self._animationCnt = 0
            end
            self._animationCnt = self._animationCnt + 1
        end
    else
        if self.log:getLeft() < 0 then
            self.nextX = self.log.nextX
            self.nextY = self.log.nextY
            self:show()
        end
    end
end

function BonusFrog:getBounds()
    if not self.skin:isVisible() then
        return nil
    end
    self.body.x = self.skin:getPositionX() - self.skin:getWidth()*0.2
    self.body.y = self.skin:getPositionY() - self.skin:getHeight()*0.2
    return self.body
end


        
function BonusFrog:move()
    if self.nextX - self.skin:getWidth()*0.5 > self.log:getNextLeft() 
            then
        self._xMove = -self.skin:getWidth()*0.5
        self.skin:setScaleX(-1)
        self.skin:setTexture(self._frogSide)
    elseif self.nextX + self.skin:getWidth()*0.5 < 
            self.log.next_right then
        self._xMove = self.skin:getWidth()*0.5
        self.skin:setScaleX(1)
        self.skin:setTexture(self._frogSide)
    end
end

