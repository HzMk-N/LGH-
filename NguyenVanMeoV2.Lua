local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua'))()

local Window = WindUI:CreateWindow({
    Title = "ARZ || NguyenVanMeo",
    Icon = "sword",
    Author = "V1.2 | Demonic Week",
    Folder = "ARZ",
    Theme = "Dark",
    Transparent = true,
    Acrylic = false,
    Size = UDim2.fromOffset(620, 480),
    Resizable = true,
    Background = "https://cdn2.tuoitre.vn/zoom/1200_1200/471584752817336320/2026/8/20/fbdfbfdbfd-17871990884091573492102-186-393-487-969-crop-178719939727143468149.jpg",
    BackgroundImageTransparency = 0.15,
})

WindUI:Notify({ Title = "ARZ", Content = "Script beta - NguyenVanNguyenn | script v1", Duration = 5 })

local MovementTab = Window:Tab({ Title = "Movement", Icon = "move" })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "settings" })

local noclipEnabled = false
local infJumpEnabled = false
local espEnabled = false
local itemEspEnabled = false
local brightEnabled = false
local speedEnabled = false
local currentSpeed = 16
local defaultSpeed = 16

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local espObjects = {}
local itemEspObjects = {}

local dangerousNames = {
    "Tall", "Charge", "Drawer", "Dragger", "Demon Eye", "DemonEye",
    "Kidnapper", "Dimension", "Red Door", "Watermelon", "Mimic", "Shy"
}

local specialNames = {
    "Statue", "Doge", "Crying"
}

local itemNames = {
    "Flashlight", "Crucifix", "Bear Trap", "BearTrap", "Bandage",
    "Shotgun", "Ammo", "Bat", "Baseball Bat", "Slap", "Revive",
    "Trap", "Security", "iPad"
}

local function isPlayerCharacter(model)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character == model then
            return true
        end
    end
    return false
end

local function getMonsterType(name)
    name = string.lower(name)
    for _, n in ipairs(dangerousNames) do
        if string.find(name, string.lower(n)) then
            return "Dangerous"
        end
    end
    for _, n in ipairs(specialNames) do
        if string.find(name, string.lower(n)) then
            return "Special"
        end
    end
    if string.find(name, "ghost") then
        return "Safe"
    end
    return "Unknown"
end

local function isItem(obj)
    local name = string.lower(obj.Name)
    for _, itemName in ipairs(itemNames) do
        if string.find(name, string.lower(itemName)) then
            return true
        end
    end
    if obj:IsA("Tool") then
        return true
    end
    return false
end

local function createESP(target)
    if not target or not target:IsA("Model") then return end
    if espObjects[target] then return end
    if isPlayerCharacter(target) then return end
    if not target:FindFirstChildOfClass("Humanoid") and not target:FindFirstChild("HumanoidRootPart") then return end

    local monsterType = getMonsterType(target.Name)
    local fillColor, outlineColor, textColor

    if monsterType == "Dangerous" then
        fillColor = Color3.fromRGB(255, 40, 40)
        outlineColor = Color3.fromRGB(255, 80, 80)
        textColor = Color3.fromRGB(255, 60, 60)
    elseif monsterType == "Special" then
        fillColor = Color3.fromRGB(255, 140, 0)
        outlineColor = Color3.fromRGB(255, 180, 50)
        textColor = Color3.fromRGB(255, 160, 30)
    elseif monsterType == "Safe" then
        fillColor = Color3.fromRGB(0, 200, 100)
        outlineColor = Color3.fromRGB(0, 255, 150)
        textColor = Color3.fromRGB(0, 255, 150)
    else
        fillColor = Color3.fromRGB(0, 200, 255)
        outlineColor = Color3.fromRGB(0, 255, 255)
        textColor = Color3.fromRGB(0, 255, 200)
    end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillTransparency = 0.45
    highlight.OutlineTransparency = 0
    highlight.FillColor = fillColor
    highlight.OutlineColor = outlineColor
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target

    local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not root then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = root
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 280, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.Parent = target

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.2
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 15
    textLabel.TextColor3 = textColor
    textLabel.Text = target.Name
    textLabel.Parent = billboard

    espObjects[target] = {
        Highlight = highlight,
        Billboard = billboard,
        Text = textLabel,
        Root = root
    }
end

local function createItemESP(target)
    if not target then return end
    if itemEspObjects[target] then return end

    local part = nil
    if target:IsA("BasePart") then
        part = target
    elseif target:IsA("Model") then
        part = target:FindFirstChildWhichIsA("BasePart") or target.PrimaryPart
    elseif target:IsA("Tool") then
        part = target:FindFirstChild("Handle") or target:FindFirstChildWhichIsA("BasePart")
    end

    if not part then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = target
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0
    highlight.FillColor = Color3.fromRGB(255, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 100)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = target

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = target

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.2
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 50)
    textLabel.Text = "[ITEM] " .. target.Name
    textLabel.Parent = billboard

    itemEspObjects[target] = {
        Highlight = highlight,
        Billboard = billboard,
        Text = textLabel,
        Root = part
    }
end

local function updateESP()
    for target, data in pairs(espObjects) do
        if target and target.Parent and data.Text and data.Root then
            local dist = (camera.CFrame.Position - data.Root.Position).Magnitude
            data.Text.Text = string.format("%s\n%.0f m", target.Name, dist)
        else
            if data.Highlight then data.Highlight:Destroy() end
            if data.Billboard then data.Billboard:Destroy() end
            espObjects[target] = nil
        end
    end
end

local function updateItemESP()
    for target, data in pairs(itemEspObjects) do
        if target and target.Parent and data.Text and data.Root then
            local dist = (camera.CFrame.Position - data.Root.Position).Magnitude
            data.Text.Text = string.format("[ITEM] %s\n%.0f m", target.Name, dist)
        else
            if data.Highlight then pcall(function() data.Highlight:Destroy() end) end
            if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
            itemEspObjects[target] = nil
        end
    end
end

local function removeESP(target)
    if espObjects[target] then
        if espObjects[target].Highlight then pcall(function() espObjects[target].Highlight:Destroy() end) end
        if espObjects[target].Billboard then pcall(function() espObjects[target].Billboard:Destroy() end) end
        espObjects[target] = nil
    end
end

local function removeItemESP(target)
    if itemEspObjects[target] then
        if itemEspObjects[target].Highlight then pcall(function() itemEspObjects[target].Highlight:Destroy() end) end
        if itemEspObjects[target].Billboard then pcall(function() itemEspObjects[target].Billboard:Destroy() end) end
        itemEspObjects[target] = nil
    end
end

local function scanMonsters()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj:FindFirstChildOfClass("Humanoid") or obj:FindFirstChild("HumanoidRootPart")) then
            if not isPlayerCharacter(obj) then
                createESP(obj)
            end
        end
    end
end

local function scanItems()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isItem(obj) then
            if obj:IsDescendantOf(player.Character) or obj:IsDescendantOf(player.Backpack) then
                continue
            end
            createItemESP(obj)
        end
    end
end

local function toggleBright(state)
    brightEnabled = state
    if state then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    end
end

local function giveTPTool()
    local tool = Instance.new("Tool")
    tool.Name = "Teleport Tool"
    tool.RequiresHandle = false
    tool.Parent = player.Backpack
    tool.Activated:Connect(function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local mouse = player:GetMouse()
        if root and mouse.Hit then
            root.CFrame = mouse.Hit + Vector3.new(0, 5, 0)
        end
    end)
end

local function setWalkSpeed(speed)
    currentSpeed = speed
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end

MovementTab:Toggle({
    Title = "Speed",
    Callback = function(v)
        speedEnabled = v
        if v then
            setWalkSpeed(currentSpeed)
        else
            setWalkSpeed(defaultSpeed)
        end
    end
})

MovementTab:Slider({
    Title = "WalkSpeed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(v)
        currentSpeed = v
        if speedEnabled then
            setWalkSpeed(v)
        end
    end
})

MovementTab:Toggle({ Title = "NoClip", Callback = function(v) noclipEnabled = v end })
MovementTab:Button({ Title = "Tool Teleport", Callback = giveTPTool })

VisualsTab:Toggle({ Title = "Bright / Fullbright", Callback = toggleBright })

VisualsTab:Toggle({
    Title = "ESP Entity, monster",
    Callback = function(v)
        espEnabled = v
        if v then
            scanMonsters()
        else
            for target, _ in pairs(espObjects) do
                removeESP(target)
            end
        end
    end
})

VisualsTab:Toggle({
    Title = "ESP Item",
    Callback = function(v)
        itemEspEnabled = v
        if v then
            scanItems()
        else
            for target, _ in pairs(itemEspObjects) do
                removeItemESP(target)
            end
        end
    end
})

UtilityTab:Button({
    Title = "Reset Character",
    Callback = function()
        if player.Character then
            player.Character:BreakJoints()
        end
    end
})

RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char then return end

    if speedEnabled then
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = currentSpeed
        end
    end

    if noclipEnabled then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if espEnabled then
        updateESP()
    end

    if itemEspEnabled then
        updateItemESP()
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

Workspace.DescendantAdded:Connect(function(desc)
    task.wait(0.4)
    
    if espEnabled then
        if desc:IsA("Model") and (desc:FindFirstChildOfClass("Humanoid") or desc:FindFirstChild("HumanoidRootPart")) then
            if not isPlayerCharacter(desc) then
                createESP(desc)
            end
        end
    end

    if itemEspEnabled then
        if isItem(desc) then
            if not desc:IsDescendantOf(player.Character) and not desc:IsDescendantOf(player.Backpack) then
                createItemESP(desc)
            end
        end
    end
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if speedEnabled then
        setWalkSpeed(currentSpeed)
    end
end)
