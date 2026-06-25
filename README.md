local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ================== TELEPORTICA - FIX BỀN VỮNG ==================
local userFrame = nil
local openButton = nil
local exitButton = nil

pcall(function()
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/Telxr/Teleportica/refs/heads/main/Telepo")))()
end)

task.wait(1.5)

local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tìm GUI lần đầu
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui:IsA("ScreenGui") then
        local frame = gui:FindFirstChildWhichIsA("ScrollingFrame")
        if frame and frame.Size.X.Offset == 300 then
            userFrame = frame
            userFrame.Visible = false
        end
        for _, btn in ipairs(gui:GetDescendants()) do
            if btn:IsA("TextButton") then
                if btn.Text == "Open" then
                    openButton = btn
                    btn.Visible = false
                elseif btn.Text == "Exit" then
                    exitButton = btn
                    btn.Visible = false
                end
            end
        end
    end
end

-- Loop chỉ ẩn nút Open xanh, không động vào danh sách TP
task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            if openButton then openButton.Visible = false end
        end)
    end
end)
-- =====================================================================

local Window = Rayfield:CreateWindow({
   Name = "LGH | Lurking Giants",
   LoadingTitle = "LGH",
   LoadingSubtitle = "The script is currently in the testing phase HNhub.",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "LGH",
      FileName = "Config"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

local noclipEnabled = false
local infJumpEnabled = false
local godEnabled = false
local espEnabled = false
local brightEnabled = false
local speedEnabled = false
local speedValue = 50

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local function toggleBright(state)
    brightEnabled = state
    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Ambient = Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    end
end

local function setFOV(value)
    camera.FieldOfView = value
end

local function updateSpeed()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if hum then
        hum.WalkSpeed = speedEnabled and speedValue or 16
    end
end

local espObjects = {}

local function createESP(target)
    if espObjects[target] then return end
    local isGiant = target.Name:find("Giant")
    local highlight = Instance.new("Highlight")
    highlight.Name = "HN.LGH_ESP"
    highlight.Adornee = target
    highlight.FillTransparency = isGiant and 0.35 or 0.6
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = isGiant and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(0, 255, 255)
    highlight.FillColor = isGiant and Color3.fromRGB(255, 40, 40) or Color3.fromRGB(0, 255, 200)
    highlight.Parent = target

    local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 260, 0, 70)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.Parent = target

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1,0,1,0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = isGiant and 17 or 14
    textLabel.TextColor3 = isGiant and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 150)
    textLabel.Parent = billboard

    espObjects[target] = {Highlight = highlight, Billboard = billboard, Text = textLabel}
end

local function updateESP()
    for target, data in pairs(espObjects) do
        if target and target.Parent and data.Text then
            local root = target:FindFirstChild("HumanoidRootPart")
            if root then
                local distance = (camera.CFrame.Position - root.Position).Magnitude
                data.Text.Text = string.format("%s\n%.0f m", target.Name, distance)
            end
        end
    end
end

local function removeESP(target)
    if espObjects[target] then
        if espObjects[target].Highlight then espObjects[target].Highlight:Destroy() end
        if espObjects[target].Billboard then espObjects[target].Billboard:Destroy() end
        espObjects[target] = nil
    end
end

local function giveTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack

    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root and mouse.Hit then
            root.CFrame = mouse.Hit + Vector3.new(0, 5, 0)
        end
    end)
end

-- UI
MainTab:CreateToggle({ Name = "God Mode", CurrentValue = false, Callback = function(Value) godEnabled = Value end })
MainTab:CreateToggle({ Name = "Infinite Jump", CurrentValue = false, Callback = function(Value) infJumpEnabled = Value end })

MovementTab:CreateToggle({ Name = "NoClip", CurrentValue = false, Callback = function(Value) noclipEnabled = Value end })

MovementTab:CreateToggle({ 
    Name = "Speed", 
    CurrentValue = false, 
    Callback = function(Value)
        speedEnabled = Value
        updateSpeed()
    end 
})

MovementTab:CreateSlider({ 
    Name = "Speed Value", 
    Range = {16, 300}, 
    Increment = 1, 
    CurrentValue = 50, 
    Callback = function(Value)
        speedValue = Value
        if speedEnabled then updateSpeed() end
    end 
})

VisualsTab:CreateToggle({ Name = "Bright / Fullbright", CurrentValue = false, Callback = toggleBright })

VisualsTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Callback = function(Value)
      espEnabled = Value
      if Value then
         for _, v in ipairs(Workspace:GetDescendants()) do
            if v:FindFirstChild("Humanoid") or v.Name:find("Giant") then
               createESP(v)
            end
         end
      else
         for target, _ in pairs(espObjects) do removeESP(target) end
      end
   end,
})

VisualsTab:CreateSlider({ Name = "POV (Field of View)", Range = {30, 150}, Increment = 1, CurrentValue = 70, Callback = setFOV })

MovementTab:CreateButton({
   Name = "Tool Teleport",
   Callback = function()
      giveTPTool()
   end,
})

-- NÚT MỞ / ĐÓNG TELEPORTICA
UtilityTab:CreateButton({
   Name = "📍 Open / Close Teleportica",
   Callback = function()
      if userFrame then
         userFrame.Visible = not userFrame.Visible
         if exitButton then
            exitButton.Visible = userFrame.Visible
         end
         Rayfield:Notify({
            Title = "Teleportica",
            Content = userFrame.Visible and "Đã MỞ danh sách TP" or "Đã ĐÓNG danh sách TP",
            Duration = 3,
         })
      else
         Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy Teleportica", Duration = 4})
      end
   end,
})

UtilityTab:CreateButton({ Name = "Reset Character", Callback = function()
    if player.Character then player.Character:BreakJoints() end
end})

-- Connections
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if hum and godEnabled then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end
    if noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    if espEnabled then updateESP() end
    if speedEnabled and hum then hum.WalkSpeed = speedValue end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

Workspace.DescendantAdded:Connect(function(desc)
    if espEnabled and (desc:FindFirstChild("Humanoid") or desc.Name:find("Giant")) then
        task.wait(0.4)
        createESP(desc)
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    updateSpeed()
end)

Rayfield:Notify({
   Title = "LGH Loaded",
   Content = "Teleportica đã fix ổn định",
   Duration = 6,
})
