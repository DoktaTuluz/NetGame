local db = require("mydebug")
require("SceneManager")

local sock = nil


    -- Menu scene class
function SceneMenu()
    local s = Scene("menu")


    function s:load()
    end


    function s:unload()
        self.changeTo = ""
    end


    function s:update(dt)
        s:updateScene(dt)

        if love.keyboard.isDown("c") then
            self.changeTo = "connect"
        end
    end


    function s:draw()
        s:drawScene()
    end

    return s
end


    -- Connection scene class
function SceneConnection(socket)
    local s = Scene("connect")

    function s:load()
        socket:init()
        sock = socket
    end


    function s:unload()
        self.changeTo = ""
    end


    function s:update(dt)
        sock:checkSocket()
        sock:update(dt)

        if sock.connected then
            self.changeTo = "gameplay"
        end

        s:updateScene(dt)
    end


    function s:draw()
        s:drawScene()
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print("Searching for a game server...")
        love.graphics.setColor(1, 1, 1, 1)
    end

    return s
end


    -- GamePlay scene class
function SceneGameplay()
    local s = Scene("gameplay")


    function s:load()
        local spr = Sprite()
        spr:addAnimation("idle", { "idle1", "idle2", "idle3", "idle4" })
        spr:playAnimation("idle")
        spr.pos:replace(100, 100)
        s:addSprite(spr)
    end


    function s:unload()
        self.changeTo = ""
        self.listSprites = {}

        sock:send(0, "DISCONNECTION", "Cut the bound with the server "..sock:getPeerServer())
    end


    function s:update(dt)

        sock:checkSocket()
        sock:update(dt)

        s:updateScene(dt)

        if love.keyboard.isDown("v") then
            self.changeTo = "menu"
        end
    end


    function s:draw()
        s:drawScene()
    end

    return s
end