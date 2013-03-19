-- FrogGame

FrogGame = class(Game)

function FrogGame:init()
    Game.init(self)
    
    self.gameData = GameData(self)
    local froggerXml = Assets.getXml("frogger.xml")
    self.imageCache = TexturePacker.parseSparrowFormat(froggerXml)
    
    self:setScreen(MenuScreen)
end

function FrogGame:updateGame(dtime)
    if self.gameData.gameMode == Game.GAME_STATE_PAUSE then
        return
    else
        self._screen:update(dtime)
    end
end