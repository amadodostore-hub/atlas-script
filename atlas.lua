-- ATLAS MAIN SCRIPT
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- CONFIGURATION
local KeyListURL = ""
local script_key = _G.script_key or ""

local function validate()
    local success, response = pcall(function() return game:HttpGet(KeyListURL) end)
    if success then
        local validKeys = loadstring(response)()
        for _, key in pairs(validKeys) do
            if tostring(key) == tostring(script_key) then return true end
        end
    end
    return false
end

if validate() then
    print("Atlas: Access Granted!")

    -- UI SETUP
    local sg = Instance.new("ScreenGui", Player.PlayerGui)
    sg.Name = "AtlasMenu"
    sg.ResetOnSpawn = false

    local main = Instance.new("Frame", sg)
    main.Size, main.Position = UDim2.new(0, 220, 0, 110), UDim2.new(0.5, -110, 0.5, -55)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    main.Active, main.Draggable = true, true
    Instance.new("UICorner", main)

    local btn = Instance.new("TextButton", main)
    btn.Size, btn.Position = UDim2.new(0, 180, 0, 40), UDim2.new(0.5, -90, 0.5, 0)
    btn.Text, btn.BackgroundColor3 = "STANDBY [Q]", Color3.fromRGB(30, 30, 50)
    btn.TextColor3, btn.Font = Color3.new(1, 1, 1), Enum.Font.GothamBold
    Instance.new("UICorner", btn)

    -- HOVER LOGIC
    local speed, height, active = 29, 12, false
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local att = Instance.new("Attachment", root)
    local v = Instance.new("LinearVelocity", root)
    v.MaxForce, v.VelocityConstraintMode, v.RelativeTo, v.Attachment0, v.Enabled = 15e5, 2, 0, att, false

    local function toggle()
        active = not active
        v.Enabled = active
        btn.Text = active and "ACTIVE" or "STANDBY [Q]"
        btn.BackgroundColor3 = active and Color3.fromRGB(80, 60, 180) or Color3.fromRGB(30, 30, 50)
    end

    btn.MouseButton1Click:Connect(toggle)
    game:GetService("UserInputService").InputBegan:Connect(function(i, p)
        if not p and i.KeyCode == Enum.KeyCode.Q then toggle() end
    end)

    game:GetService("RunService").Heartbeat:Connect(function()
        if active and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local r = Player.Character.HumanoidRootPart
            local h = Player.Character:FindFirstChild("Humanoid")
            if v.Parent ~= r then v.Parent, att.Parent = r, r end
            local ray = workspace:Raycast(r.Position, Vector3.new(0,-100,0))
            local yv = ray and (height - (r.Position.Y - ray.Position.Y)) * 7 or 0
            v.VectorVelocity = (h.MoveDirection * speed) + Vector3.new(0, yv, 0)
            h:ChangeState(11)
        end
    end)
else
    Player:Kick("Atlas: Invalid Key.")
end
