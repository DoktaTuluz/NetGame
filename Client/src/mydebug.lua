local db = {}

db.STATE = true


    -- Secure the print method so that it only logs if in debug mode
function db.Print(...)
    if STATE == false then return end
    if select("#", ...) == 0 then return end

    local toPrint = ""
    for i = 1, select("#", ...) do
        toPrint = toPrint..select(i, ...).."\t"
    end
    print(toPrint)
end


function db.Exit()
    if STATE == false then return end

    os.exit()
end

return db