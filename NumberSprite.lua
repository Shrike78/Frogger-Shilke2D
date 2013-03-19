-- NumberSprite

NumberSprite = class(GameSprite)

function NumberSprite:init(game,x,y,nameRoot)
    GameSprite.init(self,game,x,y)
    
    self._textures = {}
    self._images = {}
    self._numbers = {}
    self.value = 0

    for i = 0,10 do
        table.insert(self._textures,
            self._game.imageCache:getTexture(nameRoot..i .. ".png"))
    end
            
    self.empty = Texture.empty(self._textures[1].width,
        self._textures[1].height)
            
   -- self.y = self.y - self.empty.height * 0.5
                      
    local img
    for i = 0,8 do
        img = Image(self.empty)
        img:setPositionX(self.x + i * (self.empty.width + 2))
        img:setPositionY(self.y)
        table.insert(self._numbers,img)
        --self._game:getScreen():addChild(img)
        self._game:getScreen()._hudLayer:addChild(img)
    end
end

function NumberSprite:showValue(value)
    local s = "" .. value
    if s:len() > 8 then
        return
    end
    for i = 1, s:len() do
        local c = s:sub(i,i)
        self._numbers[i]:setTexture(self._textures[tonumber(c)+1])
    end
end
        
function NumberSprite:reset()
    for _,number in ipairs(self._numbers) do
        number:setTexture(self.empty)
    end
end

function NumberSprite:show()
    for _,number in ipairs(self._numbers) do
        number:setVisible(true)
    end
end  

function NumberSprite:hide()
    for _,number in ipairs(self._numbers) do
        number:setVisible(false)
    end
end  