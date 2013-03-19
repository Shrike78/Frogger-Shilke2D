-- TreeLog

TreeLog = class(TierSprite)

TreeLog.TREELOG_SMALL = 0
TreeLog.TREELOG_MEDIUM = 1
TreeLog.TREELOG_LARGE = 2
        
TreeLog.TEXTURE_1 = nil
TreeLog.TEXTURE_2 = nil
TreeLog.TEXTURE_3 = nil
        
function TreeLog:init(game,x,y,type)
    TierSprite.init(self,game,x,y)
    local type = type or 0
    
    if not TreeLog.TEXTURE_1 then
        TreeLog.TEXTURE_1 = game.imageCache:getTexture("log_small.png")
        TreeLog.TEXTURE_2 = game.imageCache:getTexture("log_medium.png")
        TreeLog.TEXTURE_3 = game.imageCache:getTexture("log_large.png")
    end
            
    if type == TreeLog.TREELOG_SMALL then
        self:setSkin(Image(TreeLog.TEXTURE_1))
    elseif type == TreeLog.TREELOG_MEDIUM then
        self:setSkin(Image(TreeLog.TEXTURE_2))
    elseif type == TreeLog.TREELOG_LARGE then
        self:setSkin(Image(TreeLog.TEXTURE_3))
    end
    
    self.body = Rect(0, 0, self.skin:getWidth()*0.9, 
        self.skin:getHeight())
        
    game:getScreen():addChild(self.skin)
end

function TreeLog:update(dt)
    TierSprite.update(self,dt)
    if show_log_bbox then
        self:drawBounds()
    end
end

function TreeLog:getBounds()
    self.body.x = self.skin:getPositionX() - self.body.w * 0.5
    self.body.y = self.skin:getPositionY() - self.body.h * 0.5
    return self.body
end
