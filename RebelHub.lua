local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [ AYARLAR ] --
local STATE = {
    AimTrigger = false,
    ESP = false,
    Speed = false,
    Fov = 500
}

-- [ HEDEF BULUCU ] --
local function GetTarget()
    local target, dist = nil, STATE.Fov
    local mouseLoc = UserInputService:GetMouseLocation()

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character, p.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                local ray = workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, params)
                
                if not ray then
                    local d = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                    if d < dist then dist = d; target = head end
                end
            end
        end
    end
    return target
end

-- [ ANA DÖNGÜ ] --
RunService.RenderStepped:Connect(function()
    -- ESP
    if STATE.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                local hl = p.Character:FindFirstChild("R_HL")
                if p.Character.Humanoid.Health > 0 then
                    if not hl then hl = Instance.new("Highlight", p.Character); hl.Name = "R_HL"; hl.FillColor = Color3.new(1,0,0) end
                    hl.Enabled = true
                elseif hl then hl.Enabled = false end
            end
        end
    end

    -- AIM
    if STATE.AimTrigger then
        local target = GetTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            mouse1press(); task.wait(0.01); mouse1release()
        end
    end
end)

-- [ BUFFLAR (25/34) ] --
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = STATE.Speed and 25 or 16
        hum.JumpPower = STATE.Speed and 34 or 50
        hum.UseJumpPower = true
    end
end)

-- [ ARAYÜZ ] --
local guiParent = game:GetService("CoreGui")
if guiParent:FindFirstChild("Rebel_BETA") then guiParent.Rebel_BETA:Destroy() end
local ScreenGui = Instance.new("ScreenGui", guiParent); ScreenGui.Name = "Rebel_BETA"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 240); Main.Position = UDim2.new(0.5, -120, 0.5, -120)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, 0, 1, -40); Container.Position = UDim2.new(0, 0, 0, 40)
Container.BackgroundTransparency = 1

-- BAŞLIK
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 40); Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "RebelHub BETA V0.1"; Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundTransparency = 1; Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

-- KÜÇÜLTME TUŞU
local Minimize = Instance.new("TextButton", Main)
Minimize.Size = UDim2.new(0, 30, 0, 30); Minimize.Position = UDim2.new(1, -35, 0, 5)
Minimize.Text = "_"; Minimize.TextColor3 = Color3.new(1,1,1); Minimize.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", Minimize)

local minimized = false
Minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    Container.Visible = not minimized
    Main:TweenSize(minimized and UDim2.new(0, 240, 0, 40) or UDim2.new(0, 240, 0, 240), "Out", "Quad", 0.3, true)
end)

-- BUTON EKLEME
local function AddToggle(txt, y, key)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(0.9, 0, 0, 45); btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.Text = "  " .. txt; btn.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    btn.Font = Enum.Font.Gotham; btn.TextSize = 14; btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)

    local box = Instance.new("Frame", btn)
    box.Size = UDim2.new(0, 18, 0, 18); box.Position = UDim2.new(1, -30, 0.5, -9)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        STATE[key] = not STATE[key]
        box.BackgroundColor3 = STATE[key] and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = STATE[key] and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    end)
end

AddToggle("AimTrigger (Direct)", 10, "AimTrigger")
AddToggle("Player ESP Vision", 65, "ESP")
AddToggle("Buffs (25 Speed / 34 Jump)", 120, "Speed")
