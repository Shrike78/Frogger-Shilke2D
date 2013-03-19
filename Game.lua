--Game

Game = class(DisplayObjContainer)

Game.GAME_STATE_PLAY 	= 0
Game.GAME_STATE_PAUSE 	= 1
Game.GAME_STATE_ANIMATE = 2
		
Sounds = {}
Sounds.SOUND_JUMP 			= "jump.ogg"		
Sounds.SOUND_PICKUP 		= "pickup.ogg"		
Sounds.SOUND_TARGET 		= "target.ogg"		
Sounds.SOUND_HIT 			= "hit.ogg"		
Sounds.SOUND_SPLASH 		= "splash2.ogg"		
Sounds.SOUND_OUTOFBOUNDS 	= "outofbounds.ogg"		

        
function Game:init()
    DisplayObjContainer.init(self)
    self._screens = {}
    self._screen = nil
	
	self.sounds = {}
	for i,v in pairs(Sounds) do
		self.sounds[v] = Assets.getSound(v)
	end
end

function Game:getScreen()
    return self._screen
end

function Game:setScreen(value)
    local screen
    if not self._screens[value] then 
        screen = value(self)
        self._screens[value] = screen
    else
        screen = self._screens[value]
    end
            
    if (self._screen) then
        --clear current screen
        self:removeChild(self._screen)
        self._screen:destroy()
    end
            
    self._screen = screen
    self._screen:createScreen()
    self:addChild(self._screen)
end
        
function Game:getScreenWidth()
    return 320
    --local stage = self:getStage()
    --return stage and stage:getWidth() or WIDTH
end
        
function Game:getScreenHeight()
    return 480
    --local stage = self:getStage()
    --return stage and stage:getHeight() or HEIGHT
end

function Game:updateGame(dtime)
end
