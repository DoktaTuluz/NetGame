local db = require("mydebug")
require("SceneManager")
require("Sprite")

local Game = {}
Game.Scene = nil

function Game:init()
    Game.Scene = Scene("test")
    Game.Scene:load()
end


function Game:update(dt)
    Game.Scene:update(dt)
end


function Game:draw()
    Game.Scene:draw()
end


function Game:keypressed(key)
end

return Game