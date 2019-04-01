local db = require("mydebug")
require("SceneManager")
require("UserImplementedScenes")
require("Sprite")

local sock = require("SocketConnection")

local Game = {}
Game.SceneManager = SceneManager("SceneManager")

function Game:init()
    Game.SceneManager:addScene(SceneMenu())
    Game.SceneManager:addScene(SceneConnection(sock))
    Game.SceneManager:addScene(SceneGameplay())
    Game.SceneManager:playScene("menu")
end


function Game:update(dt)
    Game.SceneManager:update(dt)
end


function Game:draw()
    Game.SceneManager:draw()
end


    -- Exit the program
local function exitProgram()
    if sock.sock ~= nil then
        sock:send(0, "DISCONNECTION", "Cut the bound with the server "..sock:getPeerServer())
    end
    os.exit()
end


function Game:keypressed(key)
    if key == "escape" then
        exitProgram()
    end
end

return Game