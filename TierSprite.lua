-- TierSprite

TierSprite = class(MovingSprite)

function TierSprite:init(game,x,y)
    MovingSprite.init(self,game,x,y)
    self.distance = 0
end