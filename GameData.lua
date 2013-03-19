-- GameData

GameData = class()

GameData.POINTS_JUMP = 10
GameData.POINTS_TARGET = 100
GameData.POINTS_FLY = 100
GameData.POINTS_BONUS = 200
        
function GameData:init(game)
    self.game = game
    self.score = 0
    self.level = 1
    self.lives = 3
    self.gameMode = Game.GAME_STATE_PAUSE
    self.tierSpeed1 = 1
    self.tierSpeed2 = 1
end

function GameData:addScore (value)
    self.score = self.score + value
    self.game:getScreen():updateScore()
end

function GameData:addLevel()
    self.level = self.level + 1
    self.game:getScreen():updateLevel()
end

function GameData:reset ()
    self.score = 0
    self.level = 1
    self.lives = 3
    self.tierSpeed1 = 1
    self.tierSpeed2 = 1
    self.game:getScreen():updateScore()
    self.game:getScreen():updateLevel()
end