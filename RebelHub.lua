local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- [ AYARLAR ] --
local STATE = {
    Aiming = false,
    ESP = false,
    Speed = false,
    Prediction = 0.05, -- Daha düşük gecikme için 0.05 (50ms)
    MagnetStrength = 25 -- Kilitlenme sertliği (Burayı artırırsan daha da sert yapışır)
}

local PID = { lastError = Vector3.new(0,0,0) }

-- [ OPTİMİZE HEDEF BULUCU ] --
local function GetTarget()
    local target, dist = nil, 600
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            local _, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                -- Duvar Kontrolü
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {LocalPlayer.Character, p.Character}
                params.FilterType = Enum.RaycastFilterType.Blacklist
                if not workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, params) then
                    local d = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                    if d < dist then dist = d; target = head end
                end
            end
        end
    end
    return target
end

-- [ ANA DÖNGÜ ] --
RunService.RenderStepped:Connect(function(dt)
    -- ESP SİSTEMİ (Hafifletilmiş)
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

    -- MAGNET-LOCK AIMBOT
    if STATE.Aiming then
        local target = GetTarget()
        if target then
            -- Tahmin Algoritması (Kafanın gideceği yeri vurur)
            local velocity = target.Parent.HumanoidRootPart.Velocity
            local predictedPos = target.Position + (velocity * STATE.Prediction)
            
            -- Sarsıntı Önleyici PID (Sadece titremeyi yok eder, hızı düşürmez)
            local error = (predictedPos - Camera.CFrame.Position).Unit
            local derivative = (error - PID.lastError) / dt
            local output = (error * 0.45) + (derivative * 0.1) -- Daha agresif Kp (0.45)
            PID.lastError = error
            
            -- Hedefe Bakış CFrame
            local targetCF = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
            
            -- Exponential Smoothing (Kusursuz Akıcılık)
            -- '25' değeri hedefe anında kilitlenmesini sağlar.
            local alpha = 1 - math.exp(-STATE.MagnetStrength * dt)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, alpha)
            
            -- Otomatik Ateş
            mouse1press(); task.wait(0.01); mouse1release()
        else
            PID.lastError = Vector3.new(0,0,0)
        end
    end
end)

-- [ ARAYÜZ ] --
local guiParent = game:GetService("CoreGui")
if guiParent:FindFirstChild("Rebel_V53") then guiParent.Rebel_V53:Destroy() end

local ScreenGui = Instance.new("ScreenGui", guiParent); ScreenGui.Name = "Rebel_V53"
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 250); Main.Position = UDim2.new(0.5, -130, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local function AddBtn(txt, y, key)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0.9, 0, 0, 45); btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30); btn.Text = txt .. " : OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        STATE[key] = not STATE[key]
        btn.Text = txt .. (STATE[key] and " : ON" or " : OFF")
        btn.BackgroundColor3 = STATE[key] and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30,30,30)
        if key == "Aiming" then Camera.CameraType = STATE.Aiming and Enum.CameraType.Scriptable or Enum.CameraType.Custom end
    end)
end

AddBtn("MAGNET AIM", 60, "Aiming")
AddBtn("PLAYER ESP", 120, "ESP")
AddBtn("WALK SPEED", 180, "Speed")

-- Hız Döngüsü
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = STATE.Speed and 28 or 16
    end
end)
