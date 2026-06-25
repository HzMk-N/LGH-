local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

MovementTab:CreateButton({
   Name = "fling giant: hướng dẫn sử dụng: đầu tiên tp đến giant (tool tp) hoặc đi đến chỗ giant và nhảy lên cho dính hitbox thân của giant thì giant sẽ bị fling.",
   Callback = function()
      loadstring(game:HttpGet("https://pastefy.app/Vf5POrA6/raw"))()
      Rayfield:Notify({
         Title = "Fling",
         Content = "You can only fling the giant; Giant has a hitbox high up, so you have to jump up to be able to fling Giant Vietsub: Bạn chỉ có thể ném gã khổng lồ; Gã khổng lồ, Vùng va chạm của nó ở vị trí khá cao, nên bạn phải nhảy lên mới có thể ném được gã khổng lồ..!",
         Duration = 4
      })
   end,
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

UtilityTab:CreateButton({ Name = "Reset Character", Callback = function()
    if player.Character then player.Character:BreakJoints() end
end})

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

    if espEnabled then
        updateESP()
    end

    if speedEnabled and hum then
        hum.WalkSpeed = speedValue
    end
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

player.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    updateSpeed()
end)

Rayfield:Notify({
   Title = "LGH Loaded",
   Content = "Script beta",
   Duration = 6,
})
