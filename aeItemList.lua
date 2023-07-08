local component = require("component")
local computer = require("computer")
local internet = require("internet")
local filesystem = require("filesystem")
local shell = require("shell")

-- Check ME interface exist ---------------------------------------------------------------------------------------------------
local mePort
if component.isAvailable("me_controller") then
    mePort = component.me_controller
    print("ME CPU ID:")
    print(mePort)
elseif component.isAvailable("me_interface") then
    mePort = component.me_interface
    print("ME Interface ID:")
    print(mePort)
else
    print("You need to connect the adapter to either a me controller or a me interface")
    os.exit()
end

-- Get Item Data ---------------------------------------------------------------------------------------------------
-- https://github.com/PoroCoco/myaenetwork/blob/main/webAux.lua
function getItemDataString()
    local string = ""
    local isModpackGTNH, storedItems = pcall(mePort.allItems) --tries the allItems method only available on the GTNH modpack. 
    if isModpackGTNH then
        for item in storedItems do
            if type(item) == 'table' then
                string = string .. item['label'] .. "~" .. item["size"] .. "~".. tostring(item["isCraftable"])..";"
            end
        end
        return string
    else
        for k,v in pairs(mePort.getItemsInNetwork()) do
            if type(v) == 'table' then
                string = string .. v['label'] .. "~" .. v["size"] .. "~".. tostring(v["isCraftable"])..";"
            end
        end
        return string
    end
end
print(getItemDataString())

