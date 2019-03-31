local db = require("mydebug")
local mathutils = require("Mathutils")
local ci = require("ContentIncludePaths")


    -- Animation class
    -- brief: Set of images that can switch to one an other
    -- It must at least have one frame to play on
local DEFAULT_FRAMERATE = 1/8
function Animation(name, listImages, speed)
    if #listImages == 0 then
        db.Print("Can't create a void animation.")
        db.Exit()
    end

    local anim = {
        name = name or tostring(anim),
        listImages = listImages,
        speedRate = speed or DEFAULT_FRAMERATE,   -- const
        frameTimer = speed or DEFAULT_FRAMERATE,  -- non const
        currentImage = 0
    }


    function anim:play()
        self.currentImage = 1
    end


    function anim:update(dt)
        self.frameTimer = self.frameTimer - dt
        if self.frameTimer <= 0 then
            self.frameTimer = self.speedRate
            self.currentImage = self.currentImage + 1
            if self.currentImage > #self.listImages then self.currentImage = 1 end
        end
    end


    function anim:getImage()
        return self.listImages[self.currentImage]
    end

    return anim
end


    -- Sprite class
    -- Everything that can be drawn onto the screen
function Sprite()
    local sprite = {
        listAnimations = {},    -- Every sprites must at least have one animation
        currentAnimation = 0,
        pos = mathutils:Position2d()
    }


    function sprite:addAnimation(name, listImages)
        if #self.listAnimations > 0 then
            for i = 1, #self.listAnimations do
                if self.listAnimations[i].name == name then
                    db.Print("Can't add twice the same animation.")
                    return
                end
            end
        end

        for i = 1, #listImages do   -- Transform the path string into a drawable element
            listImages[i] = love.graphics.newImage(ci.IMG_PATH..listImages[i]..".png")
        end

        table.insert(self.listAnimations, Animation(name, listImages))
    end


    function sprite:playAnimation(name)
        if #self.listAnimations == 0 then
            db.Print("There is no animation to play yet")
            return
        end
        if self.currentAnimation ~= 0 then
            if self.listAnimations[self.currentAnimation].name == name then
                db.Print("The animation is already playing")
            end
        end

        for i, a in pairs(self.listAnimations) do
            if a.name == name then
                self.currentAnimation = i
                self.listAnimations[self.currentAnimation]:play()
                return
            end
        end
    end


    function sprite:update(dt)
        if #self.listAnimations > 0 then
            if self.currentAnimation ~= 0 then
                self.listAnimations[self.currentAnimation]:update(dt)
            end
        end
    end


    function sprite:draw()
        if self.currentAnimation ~= 0 then
            love.graphics.draw(self.listAnimations[self.currentAnimation]:getImage(), self.pos:getPos()[1], self.pos:getPos()[2])
        end
    end

    return sprite
end