-- Lives

Lives = class(GameSprite)

function Lives:init(game,x,y)
    GameSprite.init(self,game,x,y)
    self._lives = {}

    for i = 1, game.gameData.lives do
        local img = Image(game.imageCache:getTexture("frog_stand.png"))
        img:setPosition(self.x + i * img:getWidth() + 5, self.y)
        table.insert(self._lives,img)
--        game:getScreen():addChild(img)
        game:getScreen()._hudLayer:addChild(img)
    end
end

function Lives:show()
    for _,live in ipairs(self._lives) do
        live:setVisible(true)
    end
end

function Lives:updateLives()

    for i = 1, #self._lives do
        if i-1 >= self._game.gameData.lives then
            self._lives[i]:setVisible(false)
        end
    end
end
