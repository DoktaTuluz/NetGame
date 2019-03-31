local db = require("mydebug")
local __socket__mod__ = require("socket")


local function genUUID()
    math.randomseed(os.time())
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, '[xy]',
        function (c)
            return string.format('%x', (c == 'x') and love.math.random(0, 0xf) or love.math.random(8, 0xb))
        end )
end


local SockConnection = {}
SockConnection.Target = {   -- The server connected to
    address = "",
    port = 0
}
SockConnection.UUID = ""
SockConnection.sock = nil -- The socket


function SockConnection:init(address, port)
    self.Target.address = address
    self.Target.port = port

    self.UUID = genUUID()

    self.sock = __socket__mod__.udp()
    self.sock:settimeout(0)
    self.sock:setpeername(self.Target.address, self.Target.port)
end


    -- type: int - message (0), warning (1), error (2), critical (3)
    -- cmd: string - the command we send to the server
    -- msg: string - parameters or error message
function SockConnection:send(type, cmd, msg)
    local datag = "["..cmd.."]:"..msg.."|"..self.UUID..";"
    self.sock:send(datag)
end


    -- Check if we receive something
function SockConnection:checkSocket(dt)
    local data, msg = self.sock:receive()

    if data then

        -- TODO: Manage the server commands
        -- TODO: Implement server script language

    elseif msg ~= "timeout" then
        db.Print("Network error: "..tostring(msg))
    end
end

return SockConnection