-- 🔥 RebelHub | Xeno Uyumlu AIM + TRIGGER + ESP

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local VIM = game:GetService("VirtualInputManager")

-- GUI PARENT
local guiParent = gethui and gethui() or game:GetService("CoreGui")

pcall(function()
    guiParent.RebelHub:Destroy()
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui", guiParent)
ScreenGui.Name = "RebelHub"

-- MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 430, 0, 320)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- TITLE
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(110, 0, 0)
Title.Text = "🔥 RebelHub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BorderSizePixel = 0
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

-- TAB BAR
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
TabBar.BorderSizePixel = 0

local AimTab = Instance.new("TextButton", TabBar)
AimTab.Size = UDim2.new(0.5, 0, 1, 0)
AimTab.Text = "AIM"
AimTab.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
AimTab.TextColor3 = Color3.fromRGB(255,255,255)
AimTab.Font = Enum.Font.GothamBold
AimTab.TextSize = 16
AimTab.BorderSizePixel = 0

local EspTab = Instance.new("TextButton", TabBar)
EspTab.Size = UDim2.new(0.5, 0, 1, 0)
EspTab.Position = UDim2.new(0.5, 0, 0, 0)
EspTab.Text = "ESP"
EspTab.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
EspTab.TextColor3 = Color3.fromRGB(255,255,255)
EspTab.Font = Enum.Font.GothamBold
EspTab.TextSize = 16
EspTab.BorderSizePixel = 0

-- PAGES
local Pages = Instance.new("Frame", MainFrame)
Pages.Position = UDim2.new(0, 0, 0, 80)
Pages.Size = UDim2.new(1, 0, 1, -80)
Pages.BackgroundTransparency = 1

local AimPage = Instance.new("Frame", Pages)
AimPage.Visible = true
AimPage.BackgroundTransparency = 1
AimPage.Size = UDim2.new(1,0,1,0)

local EspPage = Instance.new("Frame", Pages)
EspPage.Visible = false
EspPage.BackgroundTransparency = 1
EspPage.Size = UDim2.new(1,0,1,0)

AimTab.MouseButton1Click:Connect(function()
    AimPage.Visible = true
    EspPage.Visible = false
    AimTab.BackgroundColor3 = Color3.fromRGB(180,0,0)
    EspTab.BackgroundColor3 = Color3.fromRGB(120,0,0)
end)

EspTab.MouseButton1Click:Connect(function()
    AimPage.Visible = false
    EspPage.Visible = true
    EspTab.BackgroundColor3 = Color3.fromRGB(180,0,0)
    AimTab.BackgroundColor3 = Color3.fromRGB(120,0,0)
end)

------------------------------------------------
-- 🔲 AIM TOGGLE
------------------------------------------------
local AimToggle = Instance.new("TextButton", AimPage)
AimToggle.Size = UDim2.new(0, 200, 0, 40)
AimToggle.Position = UDim2.new(0, 20, 0, 20)
AimToggle.Text = "AIM : KAPALI"
AimToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
AimToggle.TextColor3 = Color3.fromRGB(255,255,255)
AimToggle.Font = Enum.Font.GothamBold
AimToggle.TextSize = 16
AimToggle.BorderSizePixel = 0
Instance.new("UICorner", AimToggle).CornerRadius = UDim.new(0,8)

local AimEnabled = false
AimToggle.MouseButton1Click:Connect(function()
    AimEnabled = not AimEnabled
    AimToggle.Text = AimEnabled and "AIM : AÇIK" or "AIM : KAPALI"
    AimToggle.BackgroundColor3 = AimEnabled and Color3.fromRGB(200,0,0) or Color3.fromRGB(120,0,0)
end)

------------------------------------------------
-- 🔲 TRIGGER TOGGLE
------------------------------------------------
local TriggerToggle = Instance.new("TextButton", AimPage)
TriggerToggle.Size = UDim2.new(0, 200, 0, 40)
TriggerToggle.Position = UDim2.new(0, 20, 0, 70)
TriggerToggle.Text = "TRIGGER : KAPALI"
TriggerToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
TriggerToggle.TextColor3 = Color3.fromRGB(255,255,255)
TriggerToggle.Font = Enum.Font.GothamBold
TriggerToggle.TextSize = 16
TriggerToggle.BorderSizePixel = 0
Instance.new("UICorner", TriggerToggle).CornerRadius = UDim.new(0,8)

local TriggerEnabled = false
TriggerToggle.MouseButton1Click:Connect(function()
    TriggerEnabled = not TriggerEnabled
    TriggerToggle.Text = TriggerEnabled and "TRIGGER : AÇIK" or "TRIGGER : KAPALI"
    TriggerToggle.BackgroundColor3 = TriggerEnabled and Color3.fromRGB(200,0,0) or Color3.fromRGB(120,0,0)
end)

------------------------------------------------
-- 🧲 AIMLOCK LOGIC
------------------------------------------------
local RightHolding = false
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        RightHolding = true
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 then
        RightHolding = false
    end
end)

local function IsVisible(part, character)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    return workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params) == nil
end

local function GetClosestHead()
    local closest, dist = nil, math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and IsVisible(head, plr.Character) then
                local d = (Vector2.new(pos.X,pos.Y) - Vector2.new(Mouse.X,Mouse.Y)).Magnitude
                if d < dist then
                    dist = d
                    closest = head
                end
            end
        end
    end
    return closest
end

------------------------------------------------
-- 🔫 TRIGGER LOGIC
------------------------------------------------
local firing = false
local function HeadInCrosshair()
    local vp = Camera.ViewportSize
    local ray = Camera:ViewportPointToRay(vp.X/2, vp.Y/2)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local r = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if r and r.Instance and r.Instance.Name == "Head" then
        local plr = Players:GetPlayerFromCharacter(r.Instance.Parent)
        return plr and plr ~= LocalPlayer
    end
    return false
end

------------------------------------------------
-- 🔁 MAIN LOOP
------------------------------------------------
RunService.RenderStepped:Connect(function()
    if AimEnabled and RightHolding then
        local head = GetClosestHead()
        if head then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end

    if TriggerEnabled and HeadInCrosshair() and not firing then
        firing = true
        VIM:SendMouseButtonEvent(0,0,0,true,game,0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(0,0,0,false,game,0)
        firing = false
    end
end)

------------------------------------------------
-- ✨ ESP
------------------------------------------------
local EspToggle = Instance.new("TextButton", EspPage)
EspToggle.Size = UDim2.new(0, 200, 0, 40)
EspToggle.Position = UDim2.new(0, 20, 0, 20)
EspToggle.Text = "ESP : KAPALI"
EspToggle.BackgroundColor3 = Color3.fromRGB(120,0,0)
EspToggle.TextColor3 = Color3.fromRGB(255,255,255)
EspToggle.Font = Enum.Font.GothamBold
EspToggle.TextSize = 16
EspToggle.BorderSizePixel = 0
Instance.new("UICorner", EspToggle).CornerRadius = UDim.new(0,8)

local EspEnabled = false
local EspObjects = {}

local function ClearESP()
    for _,v in pairs(EspObjects) do
        if v then v:Destroy() end
    end
    EspObjects = {}
end

local function CreateESP(plr)
    if plr == LocalPlayer or not plr.Character then return end

    local h = Instance.new("Highlight")
    h.FillColor = Color3.fromRGB(255,0,0)
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.FillTransparency = 0.4
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = plr.Character
    h.Parent = plr.Character

    local head = plr.Character:FindFirstChild("Head")
    if head then
        local bb = Instance.new("BillboardGui", head)
        bb.Size = UDim2.new(0,100,0,30)
        bb.StudsOffset = Vector3.new(0,2.5,0)
        bb.AlwaysOnTop = true

        local txt = Instance.new("TextLabel", bb)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.Text = plr.Name
        txt.TextColor3 = Color3.fromRGB(255,0,0)
        txt.TextStrokeTransparency = 0
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 14

        table.insert(EspObjects, bb)
    end

    table.insert(EspObjects, h)
end

EspToggle.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    EspToggle.Text = EspEnabled and "ESP : AÇIK" or "ESP : KAPALI"
    EspToggle.BackgroundColor3 = EspEnabled and Color3.fromRGB(200,0,0) or Color3.fromRGB(120,0,0)

    ClearESP()
    if EspEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            CreateESP(plr)
        end
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if EspEnabled then
            CreateESP(plr)
        end
    end)
end)
