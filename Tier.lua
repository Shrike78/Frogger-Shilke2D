-- Tier

Tier = class(GameSprite)

Tier.TIER_TYPE_GROUND = 0
Tier.TIER_TYPE_WATER = 1
Tier.TIER_TYPE_GRASS = 2

--the y values the frog can be at
Tier.TIER_Y = {418,388,357,328,300,272,244,216,182,149,117,84,52}
--the y values for the elements in each tier
Tier.TIER_ELEMENT_Y = {0,396,367,339,310,281,0,228,194,161,129,95,65}
        
--which tier is GROUND, or WATER or GRASS
Tier.TIER_TYPES = {0,0,0,0,0,0,0,1,1,1,1,1,2}
        
--the speeds of each Tier
Tier.TIER_SPEEDS = {0,-20,25,-20,40,-25,0,-30,20,40,-25,20,0}

Tier.UPDATABLE = {false,true,true,true,true,true,false,true,
    true,true,true,true,false}

if __USE_SIMULATION_COORDS__ then
	for i,v in ipairs(Tier.TIER_ELEMENT_Y) do
		Tier.TIER_ELEMENT_Y[i] = HEIGHT - v
	end
	for i,v in ipairs(Tier.TIER_Y) do
		Tier.TIER_Y[i] = HEIGHT - v
	end
end

function Tier:init(game,index)
    --local index = index + 1
    GameSprite.init(self, game, 0,Tier.TIER_Y[index])
    self._index = index 
    self.type = Tier.TIER_TYPES[index]
    self.speed = Tier.TIER_SPEEDS[index]
    self._elements = {}
    self.skin = nil
    self:createElements()
end

--at the start of each new level, speeds will be updated
function Tier:refresh()
    if ((self._index - 1) % 2 ~= 0) then
        self.speed = Tier.TIER_SPEEDS[self._index] * 
            self._game.gameData.tierSpeed1
    else
        self.speed = Tier.TIER_SPEEDS[self._index] *
            self._game.gameData.tierSpeed2
    end
end

local __helperRect = Rect()

function Tier:checkCollision(player)

    local collision = false
    local player_rec = player:getBounds()
    player.tierSpeed = 0
            
    for _,element in ipairs(self._elements) do
        local elemBounds = element:getBounds()
        if elemBounds ~= nil then          
            --check intersects
            if (elemBounds:intersection(player_rec,__helperRect).w > 
                    player.skin:getWidth()*0.3) then
                collision = true
                break
            end
        end
    end
            
    --if on a tier with vehicles... 
    if self.type == Tier.TIER_TYPE_GROUND then
        --if collision, kill player
        if collision then 
            return true 
        end
    --if on a tier with logs and turtles...
    elseif self.type == Tier.TIER_TYPE_WATER then
        --if no collision drown player
        if not collision then
            return true 
        end
        --else, if collision, transfer tier speed to frog 
        player.tierSpeed = self.speed
    elseif self.type == Tier.TIER_TYPE_GRASS then
        --return
    end
            
    return false
end

function Tier:getElement(index)
    return self._elements[index]
end

function Tier:update(dt)
    if Tier.UPDATABLE[self._index] then
        local nextSprite = nil
        for i=1,#self._elements do
            local sprite = self._elements[i]
            sprite.speed = self.speed
            sprite:update(dt)
            if self.speed < 0 then
                if sprite:getNextRight() <= 0 then
                    if i ~= 1 then
                        nextSprite = self._elements[i-1]
                    else
                        nextSprite = self._elements[#self._elements]
                    end
                    sprite.nextX = nextSprite.nextX + sprite.distance
                end
            else
                if sprite:getNextLeft() >
                        self._game:getScreenWidth() then
                    if i ~= #self._elements then
                        nextSprite = self._elements[i+1]
                    else
                        nextSprite = self._elements[1]
                    end
                    sprite.nextX = nextSprite.nextX - sprite.distance
                end
            end
            sprite:place()
        end
    end
end

function Tier:createElements()
    local element_x = self:getElementsX()
    local element_type = {}
    local sprite = nil
    
    --VEHICLES
    if self._index == 2 then
        for i = 1,#element_x do
            sprite = Vehicle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                Vehicle.CAR_1)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 3 then
        for i = 1,#element_x do
            sprite = Vehicle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                Vehicle.CAR_3)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 4 then
        for i = 1,#element_x do
            sprite = Vehicle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                Vehicle.CAR_4)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 5 then
        for i = 1,#element_x do
            sprite = Vehicle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                Vehicle.CAR_2)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 6 then
        for i = 1,#element_x do
            sprite = Vehicle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                Vehicle.CAR_5)
            table.insert(self._elements,sprite)
        end
    --LOGS AND TURTLES
    elseif self._index == 8 then
        element_type = {false, false, false, true, true, true, false,
            false, false}            
        for i = 1,#element_x do
            sprite = Turtle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                element_type[i])
            table.insert(self._elements,sprite)
        end
    elseif self._index == 9 then
        for i = 1,#element_x do
            sprite = TreeLog(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                TreeLog.TREELOG_SMALL)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 10 then
        for i = 1,#element_x do
            sprite = TreeLog(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                TreeLog.TREELOG_LARGE)
            table.insert(self._elements,sprite)
        end
    elseif self._index == 11 then
        element_type = {true, true, false, false, true, true, 
            false, false}            
        for i = 1,#element_x do
            sprite = Turtle(self._game,element_x[i],
                Tier.TIER_ELEMENT_Y[self._index], 
                element_type[i])
            table.insert(self._elements,sprite)
        end
    elseif self._index == 12 then
        for i = 1,#element_x do
            if i == 2 then
                sprite = Crocodile(self._game,element_x[i],
                    Tier.TIER_ELEMENT_Y[self._index])
            else
                sprite = TreeLog(self._game,element_x[i],
                    Tier.TIER_ELEMENT_Y[self._index], 
                    TreeLog.TREELOG_MEDIUM)
            end
            table.insert(self._elements,sprite)
        end
    end
    self.speed = Tier.TIER_SPEEDS[self._index]
    --calculate distance between sprites (for smoother screen wrapping)
    for i=1,#self._elements do
        --if moving to the left
        if Tier.TIER_SPEEDS[self._index] < 0 then
            --if not the first element, distance is between this 
            --element and previous element
            if i ~= 1 then
                self._elements[i].distance = self._elements[i].x - 
                    self._elements[i-1].x
            --else, distance is between this one and the last element
		else
                self._elements[i].distance = self._elements[i].x +
                    (self._game:getScreenWidth() - 
                    self._elements[#self._elements].x) +
                    sprite.skin:getWidth()
            end
        --if moving to the right
        elseif Tier.TIER_SPEEDS[self._index] > 0 then
            --if not the last element, distance is between next 
            --element and this element
            if i ~= #self._elements then
                self._elements[i].distance = self._elements[i + 1].x -
                    self._elements[i].x
            else
                self._elements[i].distance = 
                    (self._game:getScreenWidth() - self._elements[i].x)
                    + self._elements[1].x + sprite.skin:getWidth()
            end
        end
    end
end

--move elements back to original X position
function Tier:reset()
    local element_x = self:getElementsX()
    for i=1,#element_x do
        self._elements[i].x = element_x[i]
        self._elements[i].nextX = element_x[i]
        self._elements[i].skin:setPositionX(element_x[i])
    end
end

function Tier:getElementsX()
    local sw = self._game:getScreenWidth()
    
    --VEHICLES
    if self._index == 2 then
        return {
            sw*0.1,
            sw*0.4,
            sw*0.6,
            sw*0.9
        }
    elseif self._index == 3 then
        return {
            sw*0.2,
            sw*0.45,
            sw*0.7
        }
    elseif self._index == 4 then
        return {
            sw*0.3,
            sw*0.6,
            sw*0.9
        }
    elseif self._index == 5 then
        return {
            sw*0.5,
            sw*0.35
        }
    elseif self._index == 6 then
        return {
            sw*0.2,
            sw*0.5,
            sw*0.8
        }
    --LOGS AND TURTLES!!!!
    elseif self._index == 8 then
        return {
            sw*0.1,                        
            sw*0.18,
            sw*0.26, 
                                   
            sw*0.45,                        
            sw*0.53,
            sw*0.61,
                                    
            sw*0.8,                        
            sw*0.88,
            sw*0.96
        }
    elseif self._index == 9 then
        return {
            sw*0.2,                        
            sw*0.5,
            sw*0.8                      
        }
    elseif self._index == 10 then
        return {
            sw*0.2,                        
            sw*0.8                      
        }
    elseif self._index == 11 then
        return {
            sw*0.05,                        
            sw*0.13,
            
            sw*0.35,                        
            sw*0.43,                        
            
            sw*0.62,
            sw*0.70,       
                             
            sw*0.90,                        
            sw*0.98
        }
    elseif self._index == 12 then
        return {
            sw*0.15,                        
            sw*0.5,
            sw*0.85                      
        }
    end
    return {}
end
