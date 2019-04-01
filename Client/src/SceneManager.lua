local db = require("mydebug")

function SceneManager(name)
    local sm = {
        name = name or "Basic scene manager",
        listScenes = {},
        currentScene = 0
    }


    function sm:addScene(scene)
        if scene == nil then
            db.Print("Refuse to add null scene")
            return
        end

        for i, s in ipairs(self.listScenes) do
            if s.id == scene.id then
                db.Print("Can't add twice the same scene to the same scene manager.")
                return
            end
        end

        table.insert(self.listScenes, scene)
    end


    function sm:playScene(name)
        for i, s in ipairs(self.listScenes) do
            if s.id == name then
                if self:getCurrentScene() ~= nil then self:getCurrentScene():unload() end
                self.currentScene = i
                self:getCurrentScene():load()
                return
            end
        end

        db.Print("The scene manager "..self.name.." doesn't contain the scene "..name)
    end


    function sm:update(dt)
            -- Update the current scene
        if self:getCurrentScene() ~= nil then
            self:getCurrentScene():update(dt)

            if self:getCurrentScene().changeTo ~= "" then
                self:playScene(self:getCurrentScene().changeTo)
            end
        end
    end


    function sm:draw()
            -- Draw the current scene
        if self:getCurrentScene() ~= nil then
            self:getCurrentScene():draw()
        end
    end


    function sm:getCurrentScene()
        if self.currentScene == 0 then
            db.Print("There is no scene currently playing.")
            return nil
        end
        return self.listScenes[self.currentScene]
    end

    return sm
end


    -- The user-implemented Scenes must implement Scene:update(dt) and Scene:draw(), both calling updateScene(dt) and drawScene()
function Scene(name)
    local s = {
        id = name,
        listSprites = {},
        changeTo = ""
    }


    function s:load() end       -- Must be implemented by the user in its user-implemented scene


    function s:unload() end     -- Must be implemented by the user in its user-implemented scene


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


    function s:updateScene(dt)
        for i, spr in ipairs(self.listSprites) do
            spr:update(dt)
        end
    end


    function s:update(dt) end


    function s:drawScene()
        for i, spr in ipairs(self.listSprites) do
            spr:draw()
        end
    end


    function s:draw() end

    return s
end