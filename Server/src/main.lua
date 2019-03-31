local __socket__mod__ = require("socket")


    -- Interpret a given message in a table with pattern:
        -- [cmd]:msg|uuid;
local function interpret(messg)
    local message = {
        cmd = messg:sub(messg:find("%[") + 1, messg:find("]") - 1),
        msg = messg:sub(messg:find(":") + 1, messg:find("|") - 1),
        uuid = messg:sub(messg:find("|") + 1, messg:find(";") - 1)
    }

    return message
end


local udpSocket = __socket__mod__.udp()
udpSocket:settimeout(0)

udpSocket:setsockname("*", 50714)

-- MAIN LOOP
local running = true
while running do
    data, ip, port = udpSocket:receivefrom()

    if data then
        local msg = interpret(data)
        print(string.format("%d | %s on %s | %s >> [%s] %s", __socket__mod__.gettime(), ip, port, msg.uuid, msg.cmd, msg.msg))
    end

    __socket__mod__.sleep(0.001)
end