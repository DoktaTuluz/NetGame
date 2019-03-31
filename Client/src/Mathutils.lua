    -- mathutil name space
local mathutils = {}

function mathutils:Position2d(x, y)
    local pos = {
        x = x or 0,
        y = y or 0
    }


    function pos:addOnX(val)
        self.x = self.x + val
    end


    function pos:addOnY(val)
        self.y = self.y + val
    end


    function pos:replace(newX, newY)
        self.x = newX
        self.y = newY
    end


        -- When trying to access the position, prefer pos:getPos()[1] or pos:getPos()[2] rather than pos.x or pos.y
        -- Also use pos:getPos() when trying to save the position somewhere else than in the concerned object
    function pos:getPos()
        local pos = { x = self.x, y = self.y }
        return pos
    end

    return pos
end

return mathutils