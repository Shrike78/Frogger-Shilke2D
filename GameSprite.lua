-- GameSprite

GameSprite = class()

function GameSprite:init(game, x, y)
    self._game = game
    self.x = x
    self.y = y
    self.active = true
end

function GameSprite:setSkin(skin)
    self.skin = skin
    self.skin:setPosition(self.x,self.y)
end

function GameSprite:getRight()
    return self.x + self.skin:getWidth() * 0.5
end

function GameSprite:getLeft()
    return self.x - self.skin:getWidth() * 0.5
end

function GameSprite:getTop()
    return self.y + self.skin:getHeight() * 0.5
end

function GameSprite:getBottom()
    return self.y - self.skin:getHeight() * 0.5
end

function GameSprite:drawBounds()
    table.insert(postDrawList, self:getBounds())
end

function GameSprite:getBounds()
    if not self.skin then return nil end
    return Rect(self:getLeft(),self:getBottom(),
        self.skin:getWidth(),self.skin:getHeight())
end

function GameSprite:reset()
end
        
function GameSprite:update(dt)
end
        
function GameSprite:show()
    if (self.skin) then
        self.skin:setVisible(true)
    end
end
        
function GameSprite:hide()
    if (self.skin) then
        self.skin:setVisible(false)
    end
end