-- TimeMsg

TimeMsg = class(GameSprite)

function TimeMsg:init(game,x,y)
    GameSprite.init(self,game,x,y)
    self:setSkin(Image(game.imageCache:getTexture("time_box.png")))
    --game:getScreen():addChild(self.skin)
    game:getScreen()._hudLayer:addChild(self.skin)
    self.timeLabel = NumberSprite(game,
        self.x + self.skin:getWidth()*0.1,self.y,
        "number_time_")
end
