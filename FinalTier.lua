-- FinalTier

FinalTier = class(Tier)

function FinalTier:init(game,index)
    Tier.init(self,game,index)
    self._targetsReached = 0
    self._bonusCnt = 0
end


local __helperRect = Rect()

function FinalTier:checkCollision(player)

            
    local sprite
    local collision = false
    local collidingWith
    local player_rec = player:getBounds()
    player.tierSpeed = 0
    local idx
    
    for i=1,#self._targets do
        sprite = self._targets[i]
        if sprite:getBounds() then
            --check intersects
            if sprite:getBounds():intersection(player_rec,__helperRect).w >
                    player.skin:getWidth() * 0.3 then
                collision = true
                collidingWith = sprite
                idx = i
                break
            end
        end
    end
    
    if collision then
        --if this target has been reached already...
        if self._targets[idx].skin:isVisible() then
            --send player back to beginning
            player:reset()
            return false
        else
            --check if croc head is in the slot
            if self._crocs[idx].skin:isVisible() then
                --kill player!!!
                return true
            else
                local bonus = 0
                --check if there are flies in this slot
                if self._flies[idx].skin:isVisible() then
                    self._flies[idx]:hide()
                    bonus = bonus + GameData.POINTS_FLY
                end
                if player.hasBonus then
                    bonus = bonus + GameData.POINTS_BONUS
                end
                --show bonus points!!!
                if bonus > 0 then
                    if bonus > GameData.POINTS_BONUS then
                        self._bonus400[idx]:show()
                    else
                        self._bonus200[idx]:show()
                    end
                    self._game.gameData:addScore(bonus)
                    --show target reached icon after displaying 
                    --bonus for some time
                    local dcall = DelayedCall(0.5,function()
                            self._bonus400[idx]:hide()
                            self._bonus200[idx]:hide()
                            self._targets[idx]:show()
                        end
                    )
                    juggler:add(dcall)
                else
                    self._targets[idx]:show()
                end
                self._targetsReached = self._targetsReached + 1
                --_game.sounds.play(Sounds.SOUND_PICKUP)
				self._game.sounds[Sounds.SOUND_PICKUP]:play()

                
                local dcall = DelayedCall(1, function()
                        self._game:getScreen():targetReached()
                        if self._targetsReached == 5 then
                            --_game.sounds.play(Sounds.SOUND_TARGET)
							self._game.sounds[Sounds.SOUND_TARGET]:play()
                            --start new level
                            self._game:getScreen():newLevel()
                            self:hide()
                        end
                        player:reset()
                    end
                )
                juggler:add(dcall)
                self._game.gameData:addScore(GameData.POINTS_TARGET)
                player:hide()
            end
            return false
        end
    end
    return true
end

function FinalTier:update(dt)
    --debug purpose
    for _,t in pairs(self._targets) do
        t:update(dt)
    end
    
    --show fly or croc head
    for i =1, #self._crocs do
        if self._crocs[i].skin:isVisible() then
            if self._targets[i].skin:isVisible() then
                self._crocs[i].skin:setVisible(false)
            else
                if self._crocs[i].skin:getPositionX() < self._crocs[i].x then
                    self._crocs[i].skin:translate(0.4,0)
                end
            end
        end
    end
    
    if self._bonusCnt > 50 then
        self._bonusCnt = 0
        if math.random() > 0.6 then
            --pick an index
            local index = math.floor(math.random() * #self._targets) + 1 
            if not self._targets[index].skin:isVisible() and 
                    not self._flies[index].skin:isVisible() and
                    not self._crocs[index].skin:isVisible() then
                if math.random() > 0.6 then
                    self._crocs[index].skin:translate(
                        -self._crocs[index].skin:getWidth(),0)
                    self._crocs[index]:show()
                else
                    self._flies[index]:show()
                end
                local dcall = DelayedCall(4,function()
                        self._crocs[index]:hide()
                        self._flies[index]:hide()
                    end
                )
                juggler:add(dcall)
            end
        end
    end
    self._bonusCnt = self._bonusCnt + 1
end

--at the start of each new level, FinalTier mus be reset
function FinalTier:refresh()
    self:reset()
end

function FinalTier:reset()            
    self._targetsReached = 0
    self:hide()
    self._bonusCnt = 0
end

        
function FinalTier:hide()
    for i = 1,#self._targets do
        self._targets[i]:hide()
        self._flies[i]:hide()
        self._crocs[i]:hide()
        self._bonus200[i]:hide()
        self._bonus400[i]:hide()
    end
end

function FinalTier:createElements()
    self._targets = {}
    self._flies = {}
    self._crocs = {}
    self._bonus200 = {}
    self._bonus400 = {}
    
    local sprite
    local sw = self._game:getScreenWidth()
    local element_x = {
                sw*0.07,
                sw*0.29,
                sw*0.5,
                sw*0.715,
                sw*0.93
            }
            
    for i=1,#element_x do       
        sprite = Target(self._game, element_x[i], 
            Tier.TIER_ELEMENT_Y[self._index],Target.FLY)
        table.insert(self._flies,sprite)
        
        sprite = Target(self._game, element_x[i], 
            Tier.TIER_ELEMENT_Y[self._index],Target.CROC)
        table.insert(self._crocs,sprite)
        
        sprite = Target(self._game, element_x[i], 
            Tier.TIER_ELEMENT_Y[self._index],Target.TARGET)
        table.insert(self._targets,sprite)
        
        sprite = Target(self._game, element_x[i], 
            Tier.TIER_ELEMENT_Y[self._index],Target.BONUS_200)
        table.insert(self._bonus200,sprite)
        
        sprite = Target(self._game, element_x[i], 
            Tier.TIER_ELEMENT_Y[self._index],Target.BONUS_400)
        table.insert(self._bonus400,sprite)
    end
end
