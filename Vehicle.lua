-- Vehicle

Vehicle = class(TierSprite)

Vehicle.CAR_1 = 0
Vehicle.CAR_2 = 1
Vehicle.CAR_3 = 2
Vehicle.CAR_4 = 3
Vehicle.CAR_5 = 4
        
function Vehicle:init(game,x,y,type)
    TierSprite.init(self,game,x,y)
    if type == Vehicle.CAR_1 then
        self:setSkin(Image(game.imageCache:getTexture("car_1.png")))
    elseif type == Vehicle.CAR_2 then
        self:setSkin(Image(game.imageCache:getTexture("car_2.png")))
    elseif type == Vehicle.CAR_3 then
        self:setSkin(Image(game.imageCache:getTexture("car_3.png")))
    elseif type == Vehicle.CAR_4 then
        self:setSkin(Image(game.imageCache:getTexture("car_4.png")))
    elseif type == Vehicle.CAR_5 then
        self:setSkin(Image(game.imageCache:getTexture("car_5.png")))
    end
    
    game:getScreen():addChild(self.skin)
end

function Vehicle:update(dt)
    TierSprite.update(self,dt)

    if show_car_bbox then
        self:drawBounds()
    end
end