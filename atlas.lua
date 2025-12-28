print("--- Atlas Loading ---")

local Player = game.Players.LocalPlayer
local KeyListURL = "https://raw.githubusercontent.com/amadodostore-hub/atlas-script/refs/heads/main/keys.lua"

-- 1. Check if key exists in memory
local enteredKey = _G.script_key
if not enteredKey then
    warn("Atlas: No key found in _G.script_key!")
    Player:Kick("Atlas: Please use the proper loader with a key.")
    return
end

print("Atlas: Checking key...")

-- 2. Validation Logic
local function validate()
    local success, response = pcall(function() 
        return game:HttpGet(KeyListURL) 
    end)
    
    if not success then 
        warn("Atlas: Failed to fetch keys.lua from GitHub")
        return false 
    end

    local keyScript = loadstring(response)
    if not keyScript then 
        warn("Atlas: keys.lua has a syntax error!")
        return false 
    end

    local validKeys = keyScript()
    for _, key in pairs(validKeys) do
        if tostring(key) == tostring(enteredKey) then
            return true
        end
    end
    return false
end

-- 3. Run
if validate() then
    print("Atlas: Key Verified! Starting Features...")
    
    -- YOUR HOVER CODE START
    local pushSpeed, hoverHeight, active = 29, 12, false
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local att = Instance.new("Attachment", root)
    local v = Instance.new("LinearVelocity", root)
    v.MaxForce, v.VelocityConstraintMode, v.RelativeTo, v.Attachment0, v.Enabled = 15e5, 2, 0, att, false

    local g = Instance.new("ScreenGui", Player.PlayerGui)
    local m = Instance.new("Frame", g)
    m.Size, m.Position, m.BackgroundColor3, m.Active = UDim2.new(0, 220, 0, 110), UDim2.new(0.5, -110, 0.7, 0), Color3.fromRGB(10, 10, 20), true
    Instance.new("UICorner", m)
    local b = Instance.new("TextButton", m)
    b.Size, b.Position, b.Text = UDim2.new(0, 180, 0, 40), UDim2.new(0.5, -90, 0.5, 0), "STANDBY [Q]"
    
    b.MouseButton1Click:Connect(function()
        active = not active
        v.Enabled = active
        b.Text = active and "ACTIVE" or "STANDBY [Q]"
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if active and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local rt = Player.Character.HumanoidRootPart
            local hu = Player.Character:FindFirstChild("Humanoid")
            local ra = workspace:Raycast(rt.Position, Vector3.new(0,-100,0))
            local yv = ra and (hoverHeight - (rt.Position.Y - ra.Position.Y)) * 7 or 0
            v.VectorVelocity = (hu.MoveDirection * pushSpeed) + Vector3.new(0, yv, 0)
            hu:ChangeState(11)
        end
    end)
    -- YOUR HOVER CODE END
else
    print("Atlas: Invalid Key.")
    Player:Kick("Invalid Key!")
end
