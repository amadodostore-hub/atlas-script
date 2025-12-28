-- MAIN SCRIPT (atlas.lua)
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- 1. Grab the key from the executor's memory
local enteredKey = _G.script_key 

-- 2. URL of your Keys file (Make sure this link is also RAW)
local KeyListURL = "https://raw.githubusercontent.com/amadodostore-hub/atlas-script/refs/heads/main/keys.lua"

local function validate()
    local success, response = pcall(function() return game:HttpGet(KeyListURL) end)
    if success then
        -- This part assumes your keys.lua returns a table like: return {"123", "456"}
        local validKeys = loadstring(response)()
        for _, key in pairs(validKeys) do
            if tostring(key) == tostring(enteredKey) then
                return true
            end
        end
    end
    return false
end

if validate() then
    print("Atlas Hub: Access Granted!")
    
    -- [PASTE YOUR HOVER/SPEED CODE BELOW THIS LINE]
    -- Example:
    print("Script is now running...")
    
else
    Player:Kick("Atlas Hub: Invalid or Missing Key!")
end
