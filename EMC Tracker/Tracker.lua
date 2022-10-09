print("Begin!")
-- amount, new amount, item_count, emc value, total
local items = {
    flint = {0, 0, 0, 4, 0},
    gold = {0, 0, 0, 227, 0},
    iron = {0, 0, 0, 28, 0},
    copper = {0, 0, 0, 14, 0},
    zinc = {0, 0, 0, 14, 0},
}
local lifetimeITEMS = 0
local chest = peripheral.find("minecraft:barrel")
local mon = peripheral.find("monitor")
local check = true

function split(string)
    mcitems = {}
    for item in string.gmatch(string, "[^:]+") do
        if string.find(item, "_") then
            for item in string.gmatch(item, "[^_]+") do
                table.insert(mcitems, item)
            end
        end   
        table.insert(mcitems, item)
    end
    return mcitems[2]
end

while true do
    if check then
        for key, value in pairs(items) do
            value[1] = 0
        end
        start = os.time()
        for slot, item in pairs(chest.list()) do
            items[split(item.name)][1] = items[split(item.name)][1] + item.count
        end
        check = false
    end

    -- resets new amount
    for key, value in pairs(items) do
        value[2] = 0
    end
    -- checks new amount
    for slot, item in pairs(chest.list()) do
        items[split(item.name)][2] = items[split(item.name)][2] + item.count
    end

    for key, value in pairs(items) do
        if value[2] > value[1] then
            lifetimeITEMS = lifetimeITEMS + (value[2] - value[1])
            value[5] = value[5] + (value[2] - value[1])
            value[3] = value[2] - value[1]
        end
    end

    stop = os.time()
    difference = (stop - start) * 1000
    if difference >= 19.5 then
        totalEMC = 0
        totalITEMS = 0
        mon.clear()
        mon.setCursorPos(1,1)
        for key, value in pairs(items) do
            totalEMC = totalEMC + (value[3] * 64 * value[4])
            totalITEMS = totalITEMS + (value[3] * 64)


        end
        mon.write("EMC: " .. tostring(totalEMC) .. " /s")
        mon.setCursorPos(1, 2)
        mon.write("Items: " .. tostring(totalITEMS) .. " /s")

        for key, value in pairs(items) do
            cursorx, cursory = mon.getCursorPos()
            cursory = cursory + 1
            mon.setCursorPos(1, cursory)
            numPercent = math.ceil(100 * items[key][5] / lifetimeITEMS)
            mon.write(key .. ": " .. tostring(numPercent) .. "%")
        end

        check = true
        for key, value in pairs(items) do
            value[3] = 0
        end
    end
end   
