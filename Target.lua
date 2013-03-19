-- Target

Target = class(TierSprite)

Target.TARGET = 0
Target.FLY = 1
Target.CROC = 2
Target.BONUS_200 = 3
Target.BONUS_400 = 4
        
function Target:init(game,x,y,type)
    TierSprite.init(self,game,x,y)
    local type = type or 0
    self.type = type
    if type == Target.TARGET then
        self:setSkin(Image(game.imageCache:getTexture("frog_target.png")))
    elseif type == Target.FLY then
        self:setSkin(Image(game.imageCache:getTexture("fly.png")))
    elseif type == Target.CROC then
        self:setSkin(Image(game.imageCache:getTexture("alligator.png")))
    elseif type == Target.BONUS_200 then
        self:setSkin(Image(game.imageCache:getTexture("label_200.png")))
    elseif type == Target.BONUS_400 then
        self:setSkin(Image(game.imageCache:getTexture("label_400.png")))
    end
    self.body = Rect(self.x,self.y,self.skin:getWidth(),
        self.skin:getHeight())
    self:hide()
    game:getScreen():addChild(self.skin)
end

function Target:update(dt)
    TierSprite.update(self,dt)
    if show_ft_bbox then
        self:drawBounds()
    end
end
