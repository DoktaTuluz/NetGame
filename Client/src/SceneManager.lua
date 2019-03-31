local db = require("mydebug")

function Scene(name)
    local s = {
        id = name,
        listSprites = {}
    }


    function s:load()
        local spr = Sprite()
        spr:addAnimation("idle", { "idle1", "idle2", "idle3", "idle4" })
        spr:playAnimation("idle")
        spr.pos:replace(100, 100)
        s:addSprite(spr)
    end


    function s:unload()
    end


    function s:addSprite(sprite)
        if sprite == nil then
            db.Print("Can't add a null sprite.")
            return
        end

        for i, spr in ipairs(self.listSprites) do
            if sprite == spr then
                db.Print("Can't add twice the same sprite")
                return
            end
        end

        table.insert(self.listSprites, sprite)
    end


    function s:update(dt)
        for i, spr in ipairs(self.listSprites) do
            spr:update(dt)
        end
    end


    function s:draw()
        for i, spr in ipairs(self.listSprites) do
            spr:draw()
        end
    end

    return s
end