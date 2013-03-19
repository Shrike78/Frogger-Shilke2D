-- MenuScreen

MenuScreen = class(Screen)

function MenuScreen:init(game)
    Screen.init(self,game)
end

local positions = {0.3, 0.45, 0.6, 0.8, 0.98}
if __USE_SIMULATION_COORDS__ then
	for k,v in ipairs(positions) do
		positions[k] = 1-v
	end
end

function MenuScreen:createScreen()
    if #self._displayObjs == 0 then
        
        local sw = self._game:getScreenWidth()
        local sh = self._game:getScreenHeight()
        local imgCache = self._game.imageCache
        
        local bg = Quad (sw,sh)
        --argb = 0xFF666666
        bg:setColor(0x66,0x66,0x66)

        bg:setPosition(sw/2, sh/2)
        self:addChild(bg)
        
        local menuLayer = DisplayObjContainer()
        self:addChild(menuLayer)
        
        --add logo
        local logo = Image(imgCache:getTexture("logo.png"))
        logo:setPosition(sw/2, sh*positions[1])
        menuLayer:addChild(logo)

        local label1 = Image(imgCache:getTexture("label_how_to.png"))
        label1:setPosition(sw/2, sh*positions[2])
        menuLayer:addChild(label1)

        local controls = Image (imgCache:getTexture("control.png"))
        controls:setPosition(sw/2, sh*positions[3])
        menuLayer:addChild(controls)
                
        local label2 = Image (imgCache:getTexture("label_instructions.png"))
        label2:setPosition(sw/2, sh*positions[4])
        menuLayer:addChild(label2)

        local label3 = Image (imgCache:getTexture("label_tap.png"))
        label3:setPosition(sw/2, sh*positions[5])
        menuLayer:addChild(label3)
        
        self:setHittable(true)
    end
    
    self:addEventListener(Event.TOUCH,onStartTouch)
end

function MenuScreen:destroy()
    Screen.destroy(self)
    self:removeEventListener(Event.TOUCH, onStartTouch)
end

function onStartTouch(event)
    if event.touch.state == Touch.ENDED then
        event.target._game:setScreen(GameScreen)
    end
end