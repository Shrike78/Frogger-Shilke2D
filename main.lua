-- Main
--Uncomment to debug touchHandler
--__DEBUG_CALLBACKS__ = true
--__USE_SIMULATION_COORDS__ = true

WIDTH,HEIGHT = 320,480
local SAMPLERATE = 96000
local SCALEX,SCALEY = 1.5,1.5
local FPS = 60
scaleValue = 1

require("Shilke2D/include")
require("include")

IO.setWorkingDir("Assets")

--debug
postDrawList = {}
show_car_bbox = false
show_turtle_bbox = false
show_log_bbox = false
show_ft_bbox = false
show_player_bbox = false

function setup()
	
    starling = Starling.current
    juggler = starling.juggler
    stage = starling.stage
    log = starling.log
    --starling:showStats(true)    
    _game = FrogGame()
    stage:addChild(_game)
    
    _game:setScale(scaleValue,scaleValue)
end


function update(elapsedTime)
    _game:updateGame(elapsedTime)
end

function onDirectDraw()
	for _,v in ipairs(postDrawList) do
		v:draw()
	end
	table.clear(postDrawList)
end

starling = Starling(WIDTH,HEIGHT,FPS,SCALEX,SCALEY,SAMPLERATE)
starling:start()