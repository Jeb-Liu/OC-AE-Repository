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
-- print(getItemDataString())


-- HTTP POST ---------------------------------------------------------------------------------------------------
local component = require("component")
local internet = component.internet

-- 指定目标URL
local url = "http://homo.mc.yjjkds.link/add_log/"

while true do
    -- 构建HTTP请求体
    local data = getItemDataString()
    local requestBody = "data=" .. data
    
    -- 发送HTTP POST请求
    local response = internet.request(url, requestBody)
    
    -- 读取响应内容
    local responseData = ""
    for chunk in response do
      responseData = responseData .. chunk
    end
    print("HTTP响应: " .. responseData)
    
    computer.sleep(1)
end

