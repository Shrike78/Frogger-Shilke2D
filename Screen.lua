-- Screen

Screen = class(DisplayObjContainer)

function Screen:init(game)
    DisplayObjContainer.init(self)
    self._game = game
end

function Screen:createScreen()
    self._dynamicElements = {}
end

function Screen:destroy()
    self._dynamicElements = nil
end

function Screen:update(dt)
end