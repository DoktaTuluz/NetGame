local db = require("mydebug")
require("SceneManager")


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
            self.changeTo = "gameplay"
        end
    end


    function s:draw()
        s:drawScene()
    end

    return s
end


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
    end


    function s:update(dt)
        s:updateScene(dt)
<<<<<<< HEAD
        db.Print("UPDATE")
=======
>>>>>>> master

        if love.keyboard.isDown("v") then
            self.changeTo = "menu"
        end
    end


    function s:draw()
        s:drawScene()
    end

    return s
end