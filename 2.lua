-- Arsenal Mod Menu Android (Interfaz clara y botones visibles)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local settings = {
    esp = false,
    autoKill = false,
    autoPlay = false,
}

-- Crear GUI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.ResetOnSpawn = false
screenGui.Name = "ArsenalMod"

-- Botón principal
local mainBtn = Instance.new("TextButton", screenGui)
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0, 10, 0.5, -25)
mainBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainBtn.Text = "≡"
mainBtn.TextColor3 = Color3.fromRGB(255,255,255)
mainBtn.TextScaled = true
mainBtn.ZIndex = 10

-- Menú contenedor
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0, 70, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
frame.BorderSizePixel = 0
frame.Visible = false
frame.ZIndex = 9

-- Crear botón
local function makeBtn(name, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 43)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 18
    btn.Text = name .. ": OFF"
    btn.MouseButton1Click:Connect(function()
        settings[name] = not settings[name]
        btn.Text = name .. ": " .. (settings[name] and "ON" or "OFF")
    end)
    return btn
end

local espBtn     = makeBtn("esp",      10)
local killBtn    = makeBtn("autoKill", 60)
local playBtn    = makeBtn("autoPlay", 110)

-- Toggle menú con el botón principal
mainBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- <ESP>
local function createESP(player)
    if player == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.new(1, 0, 0)
    box.Transparency = 1
    box.Filled = false

    RunService.RenderStepped:Connect(function()
        if settings.esp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
                local size = 50 / dist
                box.Size = Vector2.new(size*2, size*3)
                box.Position = Vector2.new(pos.X - size, pos.Y - size*1.5)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)
end

for _, p in pairs(Players:GetPlayers()) do
    createESP(p)
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        createESP(p)
    end)
end)

-- <Auto Kill>
spawn(function()
    while true do
        task.wait(0.4)
        if settings.autoKill then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Humanoid") then
                    p.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)

-- <Auto Play>
spawn(function()
    while true do
        task.wait(0.5)
        if settings.autoPlay and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetCFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            end
        end
    end
end)