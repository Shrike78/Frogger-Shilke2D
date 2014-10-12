-- Turtle

Turtle = class(TierSprite)

Turtle.TEXTURE_1 = nil
Turtle.TEXTURE_2 = nil
Turtle.TEXTURE_3 = nil

function Turtle:init(game,x,y,animated)
    TierSprite.init(self,game,x,y)
    self._animated = animated
    self._animationCnt = 0
    
    if not Turtle.TEXTURE_1 then
        Turtle.TEXTURE_1 = game.imageCache:getTexture("turtle_1.png")
        Turtle.TEXTURE_2 = game.imageCache:getTexture("turtle_2.png")
        Turtle.TEXTURE_3 = game.imageCache:getTexture("turtle_3.png")
    end

    self:setSkin(Image(Turtle.TEXTURE_1))
    self.body = Rect(0,0,
        self.skin:getWidth()*0.8,self.skin:getHeight()*0.8)
--        self.skin:getWidth(),self.skin:getHeight())        
    game:getScreen():addChild(self.skin)
end

function Turtle:update(dt)
    TierSprite.update(self,dt)
            
    if self._animated then
        if self._animationCnt == 80 then
            self.skin:setTexture(Turtle.TEXTURE_2)
        elseif self._animationCnt == 105 then
            self.skin:setTexture(Turtle.TEXTURE_3)
        elseif self._animationCnt == 130 then
            self:hide()
        elseif self._animationCnt == 155 then          
            self:show()
        elseif self._animationCnt == 185 then
			self.skin:setTexture(Turtle.TEXTURE_2)
        elseif self._animationCnt == 210 then
            self.skin:setTexture(Turtle.TEXTURE_1)
            self._animationCnt = 0
        end
        self._animationCnt = self._animationCnt + 1
    end
    
    if show_turtle_bbox then
        self:drawBounds()
    end
end

function Turtle:getBounds()
    if not self.skin:isVisible()--[[ or 
            self.skin.texture == Turtle.TEXTURE_3 --]] then
        return nil
    end
    
--    self.body.x = self.skin:getPositionX() - self.skin:getWidth() * 0.2
--    self.body.y = self.skin:getPositionY() - self.skin:getHeight() * 0.2
    self.body.x = self.skin:getPositionX() - self.body.w/2
    self.body.y = self.skin:getPositionY() - self.body.h/2
    return self.body
end