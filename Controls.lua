-- Controls

Controls = class(GameSprite)

function Controls:init(game,x,y)
    GameSprite.init(self,game,x,y)
    self:setSkin(Image(game.imageCache:getTexture("control.png")))
    
    --game:getScreen():addChild(self.skin)
    game:getScreen()._hudLayer:addChild(self.skin)
    self._center = vec2(x,y)
end

function Controls:getDirection(p)
    local c = self._center * scaleValue
    local diff = p - c
    
    local rad = math.atan2(diff.y,diff.x)
    
    local angle = math.deg(rad)
    if angle < 360 then angle = angle + 360 end
    if angle > 360 then angle = angle - 360 end
    
    if angle > 315 or angle < 45 then
        return Player.MOVE_RIGHT
    elseif angle >= 45 and angle <= 135 then
if __USE_SIMULATION_COORDS__ then		
        return Player.MOVE_TOP
else
        return Player.MOVE_DOWN
end
    elseif angle > 135 and angle < 225 then
        return Player.MOVE_LEFT
    else
if __USE_SIMULATION_COORDS__ then		
        return Player.MOVE_DOWN
else
        return Player.MOVE_TOP
end
    end
end
