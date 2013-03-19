-- Crocodile

Crocodile = class(TierSprite)

Crocodile.TEXTURE_1 = nil
Crocodile.TEXTURE_2 = nil

function Crocodile:init(game,x,y)
    TierSprite.init(self,game,x,y)
    self._animationCnt = 0
    if not Crocodile.TEXTURE_1 then
        Crocodile.TEXTURE_1 = game.imageCache:getTexture("croc_1.png")
        Crocodile.TEXTURE_2 = game.imageCache:getTexture("croc_2.png")
    end
    self:setSkin(Image(Crocodile.TEXTURE_1))
    game:getScreen():addChild(self.skin)
    self.body = Rect(0,0,self.skin:getWidth(),self.skin:getHeight())
end

function Crocodile:update(dt)
    TierSprite.update(self,dt)
    if self._animationCnt == 60 then
        self.skin:setTexture(Crocodile.TEXTURE_2)
        self.body.w = self.skin:getWidth()*0.4
    elseif self._animationCnt == 160 then
        self.skin:setTexture(Crocodile.TEXTURE_1)
        self.body.w = self.skin:getWidth()
        self._animationCnt = 1
    end
    self._animationCnt = self._animationCnt + 1
end

function Crocodile:getBounds()
    self.body.x = self.skin:getPositionX() - self.body.w*0.5
    self.body.y = self.skin:getPositionY() - self.body.h*0.5
    return self.body
end