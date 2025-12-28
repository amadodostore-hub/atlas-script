local Player = game.Players.LocalPlayer
local KeyListURL = "https://raw.githubusercontent.com/amadodostore-hub/atlas-script/refs/heads/main/keys.lua"

-- 1. Grab the key from the loader
local enteredKey = _G.script_key or ""

-- 2. Check if the key is valid
local function validate()
    local success, keyListRaw = pcall(function() return game:HttpGet(KeyListURL) end)
    if success then
        local validKeys = loadstring(keyListRaw)()
        for _, key in pairs(validKeys) do
            if tostring(key) == tostring(enteredKey) then
                return true
            end
        end
    end
    return false
end

-- 3. Run or Kick
if validate() then
    print("Astral Hub: Key Verified!")
    
    -------------------------------------------------------
    -- PASTE YOUR WHOLE ASTRAL HOVER/SPEED SCRIPT BELOW --
    -------------------------------------------------------
    
    local pushSpeed, hoverHeight, active = 29, 12, false
    -- (The rest of your hover logic goes here...)

else
    Player:Kick("Invalid Key! Please purchase or get a key from the owner.")
end
