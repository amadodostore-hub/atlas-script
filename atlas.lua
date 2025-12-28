-- [[ ASTRAL HOVER BYPASS: KEY SYSTEM EDITION ]]
local Player = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- 1. KEY SYSTEM CONFIGURATION
local KeyListURL = "https://raw.githubusercontent.com/amadodostore-hub/atlas-script/refs/heads/main/keys.lua" -- Replace this!
local enteredKey = _G.script_key or ""

local function validate()
    local success, response = pcall(function() return game:HttpGet(KeyListURL) end)
    if success then
        local validKeys = loadstring(response)()
        for _, key in pairs(validKeys) do
            if tostring(key) == tostring(enteredKey) then return true end
        end
    end
    return false
end

-- 2. START MAIN SCRIPT IF VALID
if validate() then
    print("Astral Hub: Access Granted!")

    -- CONFIGURATION
    local pushSpeed = 29
    local hoverHeight = 12
    local active = false
    local toggleKey = Enum.KeyCode.Q 

    -- Setup Physics
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    local att = Instance.new("Attachment", root)
    local velocityForce = Instance.new("LinearVelocity", root)
    velocityForce.MaxForce = 1500000
    velocityForce.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocityForce.RelativeTo = Enum.ActuatorRelativeTo.World
    velocityForce.Attachment0 = att
    velocityForce.Enabled = false

    -- UI Construction
    local sg = Instance.new("ScreenGui", Player.PlayerGui)
    sg.Name = "AstralHub"
    sg.ResetOnSpawn = false

    local main = Instance.new("Frame", sg)
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 220, 0, 130)
    main.Position = UDim2.new(0.5, -110, 0.75, 0)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    main.Active = true

    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 15)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Thickness = 3
    mainStroke.Color = Color3.fromRGB(45, 45, 80)
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "A S T R A L"
    title.TextColor3 = Color3.fromRGB(180, 180, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    local keyText = Instance.new("TextLabel", main)
    keyText.Size = UDim2.new(1, 0, 0, 20)
    keyText.Position = UDim2.new(0, 0, 0, 35)
    keyText.BackgroundTransparency = 1
    keyText.Text = "[ KEYBIND: " .. toggleKey.Name .. " ]"
    keyText.TextColor3 = Color3.fromRGB(100, 100, 150)
    keyText.Font = Enum.Font.Code
    keyText.TextSize = 10

    local btn = Instance.new("TextButton", main)
    btn.Name = "EngageButton"
    btn.Size = UDim2.new(0, 180, 0, 45)
    btn.Position = UDim2.new(0.5, -90, 0.55, 0)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Text = "SYSTEM STANDBY"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    -- Toggle Logic
    local function toggleScript()
        active = not active
        velocityForce.Enabled = active
        if active then
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(70, 50, 150)}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(100, 100, 255)}):Play()
            btn.Text = "SYSTEM ACTIVE"
        else
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 40)}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(45, 45, 80)}):Play()
            btn.Text = "SYSTEM STANDBY"
        end
    end

    btn.MouseButton1Click:Connect(toggleScript)
    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp and input.KeyCode == toggleKey then toggleScript() end
    end)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Hover Engine
    RunService.Heartbeat:Connect(function()
        local currentChar = Player.Character
        local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local hum = currentChar and currentChar:FindFirstChild("Humanoid")
        if not currentRoot or not hum then return end
        if velocityForce.Parent ~= currentRoot then velocityForce.Parent, att.Parent = currentRoot, currentRoot end

        if active then
            local p = RaycastParams.new()
            p.FilterDescendantsInstances = {currentChar}
            local ray = workspace:Raycast(currentRoot.Position, Vector3.new(0, -100, 0), p)
            local yv = 0
            if ray then yv = (hoverHeight - (currentRoot.Position.Y - ray.Position.Y)) * 7 end

            if hum.MoveDirection.Magnitude > 0 then
                velocityForce.VectorVelocity = Vector3.new(hum.MoveDirection.X * pushSpeed, yv, hum.MoveDirection.Z * pushSpeed)
            else
                velocityForce.VectorVelocity = Vector3.new(0, yv, 0)
            end
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end)

else
    -- Access Denied Logic
    Player:Kick("Astral Hub: Invalid Key.")
end
