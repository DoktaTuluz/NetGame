local db = require("mydebug")
require("SceneManager")
require("UserImplementedScenes")
require("Sprite")

local Game = {}
Game.SceneManager = SceneManager("SceneManager")

function Game:init()
    Game.SceneManager:addScene(SceneMenu())
    Game.SceneManager:addScene(SceneGameplay())
    Game.SceneManager:playScene("menu")
end


function Game:update(dt)
    Game.SceneManager:update(dt)
end


function Game:draw()
    Game.SceneManager:draw()
end


function Game:keypressed(key)
end

return Game