-- MovingSprite

MovingSprite = class(GameSprite)

MovingSprite.UP = 0
MovingSprite.DOWN = 1
MovingSprite.LEFT = 2
MovingSprite.RIGHT = 3


function MovingSprite:init(game,x,y)
    GameSprite.init(self,game,x,y)
    self.nextX = x
    self.nextY = y
    self.vx = 0
    self.vy = 0
    self.speed = 0
end

function MovingSprite:getNextRight()
    return self.x + self.skin:getWidth() * 0.5
end

function MovingSprite:getNextLeft()
    return self.x - self.skin:getWidth() * 0.5
end

function MovingSprite:getNextTop()
    return self.y + self.skin:getHeight() * 0.5
end

function MovingSprite:getNextBottom()
    return self.y - self.skin:getHeight() * 0.5
end

function MovingSprite:getNextBounds()
    return Rect(self:getNextLeft(),self:getNextBottom(),
        self.skin:getWidth(),self.skin:getHeight())
end

function MovingSprite:update(dt)
    self.nextX = self.nextX + self.speed * dt
end
        
function MovingSprite:place()
    self.x = self.nextX
    self.y = self.nextY            
    self.skin:setPosition(self.x,self.y)
end
